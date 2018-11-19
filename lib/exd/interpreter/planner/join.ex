defmodule Exd.Interpreter.Join do
  @moduledoc """
  From clause
  """
  alias Exd.Query
  alias Exd.Record
  alias Exd.Interpreter.Planner

  @type option :: {:max_demand, integer()}
    | {:min_demand, integer()}
    | {:stages, integer()}

  @type options :: [option]

  @doc """
  Creates a new flow from source
  """
  @spec join(Flow.t, binary(), any(), options()) :: Flow.t
  def join(flow, namespace, specable, opts \\ []) when is_function(specable) do
    max_demand = Keyword.get(opts, :max_demand, 1)
    min_demand = Keyword.get(opts, :min_demand, 0)
    stages = Keyword.get(opts, :stages, 1)

    subscription_opts = [
      max_demand: max_demand,
      min_demand: min_demand,
      stages: stages
    ]

    adapter_spec = {Exd.Source.Function, fn: specable}
    source_opts = [adapter: adapter_spec, namespace: namespace]
    spec = {Exd.Mapper, source_opts}
    specs =  [{spec, subscription_opts}]

    flow
    |> Flow.through_specs(specs)
  end

  def join(flow, namespace, %Query{} = specable, opts) do
    flow
    |> Flow.flat_map(fn record ->
      query =
        opts
        |> Enum.reduce(specable, fn {key, value}, acc ->
          Query.set(acc, key, Exd.Resolvable.resolve(value, record))
        end)

        for result <- Query.to_list(query) do
        Record.put(record, namespace, result)
      end
    end)
  end

  def join(flow, namespace, value, opts) when is_list(value) do
    flow
    |> Flow.map(fn record ->
      record
    end)
  end

end
