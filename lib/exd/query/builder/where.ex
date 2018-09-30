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
  @spec escape(Macro.t, Macro.Env.t) :: {Macro.t, Keyword.t}
  def escape({:and, _, [left, right]}, env) do
    wheres = [escape(left, env), escape(right, env)]
  end
  def escape({operator, _, [left, right]}, env) do
    {
      :{},
      [],
      [
        Exd.Query.Builder.Select.escape(left, env),
        operator,
        Exd.Query.Builder.Select.escape(right, env)
      ]
    }
  end

  @doc """
  Builds select clause
  """
  def build(query, binds, expr, env) do
    wheres = escape(expr, env) |> IO.inspect
    Builder.apply_query(query, __MODULE__, [wheres], env)
  end

  def apply(%Query{where: []} = query, wheres) when is_list(wheres) do
    %{query | where: wheres}
  end

  def apply(%Query{} = query, wheres) when is_list(wheres) do
    %{query | where: query.where ++ wheres}
  end

  def apply(%Query{} = query, where) do
    %{query | where: query.where ++ [where]}
  end

end
