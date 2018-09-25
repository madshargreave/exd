defmodule Exd.Query.Builder.Where do
  @moduledoc false
  alias Exd.Query.Builder
  alias Exd.Query

  @doc """
  Handles from expressions

  The expressions may either contain an `in` expression or not.
  The right side is always expected to Queryable.

  ## Example

      # iex> escape(quote do: r.test == 200)
      # {:{}, [], ["r.test", :==, 200]}
  """
  @spec escape(Macro.t) :: {Macro.t, Keyword.t}
  def escape({operator, _, [left, right]}) do
    {escape(left), operator, escape(right)}
  end
  def escape({{:., _, [{binding, _, nil}, path]}, _, []}), do: escape({binding, [], path})
  def escape({binding, _, nil}) when is_atom(binding), do: {:binding, Atom.to_string(binding), []}
  def escape({binding, _, path}) when is_atom(binding), do: {:binding, Atom.to_string(binding), escape(path)}
  def escape(binding) when is_atom(binding), do: Atom.to_string(binding)
  def escape(binding), do: binding

  @doc """

  """
  def build(query, binding, expr, env) do
    where = escape(expr)
    %Query{query | where: query.where ++ [where]}
  end

end
