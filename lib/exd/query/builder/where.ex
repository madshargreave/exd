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
  def escape({{:., _, args}, _, []}), do: Enum.join((for arg <- args, do: escape(arg)), ".")
  def escape({binding, _, nil}) when is_atom(binding), do: binding
  def escape(binding), do: binding

  @doc """

  """
  def build(query, binding, expr, env) do
    where = escape(expr)
    %Query{query | where: query.where ++ [where]}
  end

end
