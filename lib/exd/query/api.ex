defmodule Exd.Query.API do
  @moduledoc """
  API for constructing queries using macros
  """
  alias Exd.Query
  alias Exd.Query.Builder.From

  defmacro from(expr, opts \\ []) do
    unless Keyword.keyword?(opts) do
      raise ArgumentError, "second argument to `from` must be a compile time keyword list"
    end
    query = From.build(expr, __CALLER__, nil)
    do_from(opts, query)
  end

  @binds ~w(where or_where select select_merge)a
  @functions ~w(add subtract multiply divide interpolate regex replace range unnest)a

  defp do_from([{type, expr} | rest], query) when type in @binds do
    query = Exd.Query.API.unquote(type, expr, query)
    do_from(rest, query)
  end

  defp do_from([], query) do
    Macro.escape(query)
  end

  def unquote(:where, {operator, _, [{binding_and_attr, _, _}, value]}, query) do
    binding = Exd.Query.API.unquote_binding(binding_and_attr)
    Query.where(query, binding, operator, value)
  end

  def unquote(:select, expr, query) do
    Query.select(query, Exd.Query.API.unquote_literal(expr))
  end

  def unquote_literal({:%{}, _, args}) do
    for {key, value} <- args, into: %{}, do: {key, unquote_literal(value)}
  end
  def unquote_literal({:{}, _, args} = expr) do
    List.to_tuple(args)
  end
  def unquote_literal({binding, _, [func]} = expr) when binding in @functions do
    {unquote_literal(binding), unquote_literal(func)}
  end
  def unquote_literal({binding, _, [func, arg1]}) when binding in @functions do
    {binding, unquote_literal(func), unquote_literal(arg1)}
  end
  def unquote_literal({binding, _, [func, arg1, arg2]}) when binding in @functions do
    {binding, unquote_literal(func), unquote_literal(arg1), unquote_literal(arg2)}
  end
  def unquote_literal({:., _, [left, right]}), do: "#{unquote_literal(left)}.#{unquote_literal(right)}"
  def unquote_literal({:sigil_r, _, [{:<<>>, _, [regex]}, []]}) do
    Regex.compile!(regex)
  end
  def unquote_literal({binding, _, nil}) when is_atom(binding), do: Atom.to_string(binding)
  def unquote_literal({binding, _, _}) when is_tuple(binding), do: unquote_literal(binding)
  def unquote_literal(exprs) when is_list(exprs), do: for expr <- exprs, do: unquote_literal(expr)
  def unquote_literal(expr) when is_binary(expr), do: "'#{expr}'"
  def unquote_literal(expr) do
    expr
  end

  def unquote_binding({:., _, [{binding, _, _}, attr]}) do
    "#{binding}.#{attr}"
  end

  def quote_expr(expr) when is_tuple(expr) do
    expr
    |> Tuple.to_list
    |> Enum.map(fn value ->
        if is_binary(value), do: "'#{value}'", else: value
    end)
    |> List.to_tuple
  end
  def quote_expr(expr), do: expr

end
