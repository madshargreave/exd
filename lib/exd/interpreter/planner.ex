defmodule Exd.Interpreter.Planner do
  @moduledoc """
  Plans the execution of a query
  """
  alias Exd.Query
  alias Exd.Query.Rewriter
  alias Exd.Interpreter.{From, Join, Where, Select, Flatten, Into}

  @doc """
  Plan query flow
  """
  @spec plan(Query.t()) :: Flow.t()
  def plan(%Query{} = query) do
    query
    |> plan_query
    |> plan_resolve
  end

  @doc """
  Plans query flow
  """
  @spec plan_query(Query.t()) :: Flow.t()
  def plan_query(%Query{} = query) do
    query = Rewriter.rewrite(query)
    flow = plan_from(query)

    flow
    |> plan_joins(query)
    |> plan_wheres(query)
    |> plan_select(query)
    |> plan_flatten(query)
    |> plan_into(query)
  end

  defp plan_from(%Query{from: {namespace, specable, opts}, env: env} = query) do
    From.from(namespace, specable, opts, env)
  end
  defp plan_from(%Query{from: {namespace, specable}, env: env} = query),
    do: plan_from(%Query{query | from: {namespace, specable, []}})

  defp plan_joins(flow, %Query{joins: joins} = _query) do
    joins
    |> Enum.reduce(flow, fn %{from: {namespace, specable, opts}} = _join, flow ->
      Join.join(flow, namespace, specable, opts)
    end)
  end

  defp plan_wheres(flow, %Query{where: wheres} = _query) do
    wheres
    |> Enum.reduce(flow, fn {field, relation, value} = _where, flow ->
      Where.where(flow, field, relation, value)
    end)
  end

  defp plan_select(flow, %Query{select: nil} = query), do: flow
  defp plan_select(flow, %Query{select: select, env: env} = query) do
    Select.select(flow, select, env)
  end

  defp plan_flatten(flow, %Query{flatten: flatten} = _query) do
    Flatten.flatten(flow, flatten)
  end

  defp plan_into(flow, %Query{into: nil} = _query), do: flow
  defp plan_into(flow, %Query{into: sink}) do
    Into.into(flow, sink)
  end

  defp plan_resolve(flow) do
    Flow.map(flow, &(&1.value))
  end

end
