defmodule Exd.Query.Builder.From do
  @moduledoc """
  ...
  """
  alias Exd.Query.Builder
  alias Exd.Query

  @doc """
  Escapes bindings in query
  """
  @spec escape_binding(Macro.t) :: {Macro.t, list}
  def escape_binding({binding, _, _}) when is_atom(binding) do
    # Atom.to_string(binding)
    binding
  end

  @doc """
  Escapes quoted expressions

  ## Examples

      iex> escape(quote(do: [1, 2, 3]))
      {quote(do: [1, 2, 3]), []}

      iex> escape(quote(do: b in [1, 2, 3]))
      {quote(do: [1, 2, 3]), "b"}

      iex> my_list = [1, 2, 3]
      iex> escape(quote(do: b in my_list))
      {quote(do: my_list), "b"}
  """
  @spec escape(Macro.t) :: {Macro.t, list}
  def escape({:in, _, [var, query]}) do
    {query, escape_binding(var)}
  end
  def escape(query) do
    {query, []}
  end

  @doc """
  Returns a quoted expression
  """
  @spec build(Macro.t, Macro.Env.t) :: {Macro.t, Keyword.t}
  def build(expr, env) do
    {query, binds} = escape(expr)
    opts = []
    quoted =
      case expand_from(query, env) do
        queryable when is_list(queryable) ->
          build_query(query, binds, opts)
        {name, _, nil} ->
          build_query(query, binds, opts)
        {func, _, args} when is_list(args) ->
          build_query({func, args}, binds, opts)
      end
    {quoted, binds}
  end

  defp build_query(queryable, binds, opts) do
    {:%, [], [Exd.Query, {:%{}, [], [from: {binds, queryable}]}]}
  end

  defp expand_from({left, right}, env) do
    {left, Macro.expand(right, env)}
  end
  defp expand_from(other, env) do
    Macro.expand(other, env)
  end


end
