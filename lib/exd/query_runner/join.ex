defmodule Exd.Runner.Join do
  @moduledoc """
  From clause
  """

  @type option :: {:max_demand, integer()}
    | {:min_demand, integer()}
    | {:stages, integer()}

  @type options :: [option]

  @doc """
  Creates a new flow from source
  """
  @spec join(Flow.t, binary(), any(), options()) :: Flow.t
  def join(flow, namespace, specable, opts \\ []) do
    max_demand = Keyword.get(opts, :max_demand, 1)
    min_demand = Keyword.get(opts, :min_demand, 0)
    stages = Keyword.get(opts, :stages, 1)

    subscription_opts = [
      max_demand: max_demand,
      min_demand: min_demand,
      stages: stages
    ]

    # adapter_spec = Exd.Specable.to_spec(specable)
    adapter_spec = {Exd.Source.Function, fn: specable}
    source_opts = [adapter: adapter_spec, namespace: namespace]
    spec = {Exd.Mapper, source_opts}
    specs =  [{spec, subscription_opts}]

    flow
    |> Flow.through_specs(specs)
  end

end
