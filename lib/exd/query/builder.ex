defmodule Exd.Query.Builder do
  @moduledoc """
  API for constructing queries using macros
  """
  alias Exd.Query
  alias Exd.Query.Builder.{From, Where, Select}

  @doc """
  Creates a query

  ## Keywords example

      from(n in [1, 2, 3], select: n)
  """
  defmacro from(expr, opts \\ []) do
    unless Keyword.keyword?(opts) do
      raise ArgumentError, "second argument to `from` must be a compile time keyword list"
    end
    {quoted, binds} = From.build(expr, __CALLER__)
    from(opts, quoted, binds, __CALLER__)
  end

  @binds ~w(where or_where select select_merge)a
  @functions ~w(add subtract multiply divide interpolate regex replace range unnest)a

  defp from([{type, expr} | rest], quoted, binds, env) when type in @binds do
    quoted =
      quote do
        Exd.Query.Builder.unquote(type)(unquote(quoted), unquote(binds), unquote(expr))
      end

    from(rest, quoted, binds, env)
  end

  defp from([], quoted, _binds, _env) do
    quoted
  end

  @doc """
  Creates a select expression
  """
  defmacro select(query, binds \\ [], expr) do
    Select.build(query, binds, expr, __CALLER__)
  end

  @doc """

  """
  def apply_query(query, module, args, env) do
    query = Macro.expand(query, env)
    case unescape_query(query) do
      # %Exd.Query{} = unescaped ->
      #   apply(module, :apply, [unescaped | args])
      #   |> escape_query
      _ ->
        quote do
          query = unquote(query) # Unquote the query for any binding variable
          unquote(module).apply(query, unquote_splicing(args))
        end
    end
  end

  # Unescapes an `Exd.Query` struct.
  defp unescape_query({:%, _, [Exd.Query, {:%{}, _, list}]}) do
    struct(Exd.Query, list)
  end
  defp unescape_query({:%{}, _, list} = ast) do
    if List.keyfind(list, :__struct__, 0) == {:__struct__, Exd.Query} do
      Enum.into(list, %{})
    else
      ast
    end
  end
  defp unescape_query(other) do
    other
  end

  # Escapes an `Exd.Query` and associated structs.
  defp escape_query(%Exd.Query{} = query) do
    Macro.escape(query)
  end

end
