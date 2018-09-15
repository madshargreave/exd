defmodule Exd.Runner.From do
  @moduledoc """
  From clause
  """
  alias Exd.Record, as: ExdRecord

  @type option :: {:max_demand, integer()}
    | {:min_demand, integer()}
    | {:stages, integer()}
    | {:window, Flow.Window.t}
    | {:key, function()}

  @type options :: [option]

  @doc """
  Creates a new flow from source
  """
  @spec from(binary(), any(), options()) :: Flow.t
  def from(namespace, specable, opts \\ []) do
    max_demand = Keyword.get(opts, :max_demand, 1)
    min_demand = Keyword.get(opts, :min_demand, 0)
    stages = Keyword.get(opts, :stages, 1)
    window = Keyword.get(opts, :window, Flow.Window.global)
    key_fn = Keyword.get(opts, :key, &default_hash/1)

    subscription_opts = [
      max_demand: max_demand,
      min_demand: min_demand,
      stages: stages,
      window: window
    ]

    adapter_spec = Exd.Specable.to_spec(specable)
    source_opts = [adapter: adapter_spec]
    specs =  [{Exd.Source, source_opts}]

    specs
    |> Flow.from_specs(subscription_opts)
    |> Flow.map(fn event -> %{ namespace => event } end)
    |> Flow.map(&to_record(&1, key_fn))
  end

  defp to_record(event, key_fn) do
    key = key_fn.(event)
    ExdRecord.new(key, event)
  end

  # Uses the sha256 hash of the record to generate a new key
  defp default_hash(record) do
    :crypto.hash(:sha256, inspect(record))
    |> Base.encode16
  end

end