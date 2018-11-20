defmodule Exd.Query.Builder.Join do
  @moduledoc false
  alias Exd.Query.Builder
  alias Exd.Query
  alias Exd.Query.Builder.From, as: FromBuilder

  @doc """
  Escapes bindings in query
  """
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
  def escape({:in, _, [var, query]}, env) do
    {escape(query, env), query, escape_binding(var)}
  end
  def escape({:subquery, _, expr}, env) do
    {:subquery, [FromBuilder.escape(expr)]}
  end

  @doc """
  Builds into clause
  """
  def build(query, type, binds, join_expr, env) do
    # IO.inspect query
    join_expr = {type, escape(join_expr, env)}
    Builder.apply_query(query, __MODULE__, [join_expr], env)
  end

  def apply(%Query{} = query, join) do
    %{query | joins: query.joins ++ [join]}
  end

end
