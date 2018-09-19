defmodule Exd.Runner.Planner do
  @moduledoc """
  Plans the execution of a query
  """
  alias Exd.Query
  alias Exd.Runner.{From, Join, Where, Select, Flatten, Into, Commit}

  @doc """
  Plan query flow
  """
  @spec plan(Query.t()) :: Flow.t()
  def plan(%Query{} = query) do
    query
    |> plan_from
    |> plan_joins(query)
    |> plan_wheres(query)
    |> plan_select(query)
    |> plan_flatten(query)
    |> plan_into(query)
  end

  defp plan_from(%Query{from: {namespace, specable, opts}}) do
    From.from(namespace, specable, opts)
  end

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
  defp plan_select(flow, %Query{select: select} = _query) do
    Select.select(flow, select)
  end

  defp plan_flatten(flow, %Query{select: nil} = _query), do: flow
  defp plan_flatten(flow, %Query{select: select} = _query) do
    Flatten.flatten(flow, select)
  end


  defp plan_into(flow, %Query{into: nil} = _query), do: flow
  defp plan_into(flow, %Query{into: {namespace, sink}}) do
    Into.into(flow, sink)
  end

end
