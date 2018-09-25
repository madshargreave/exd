defmodule Exd.Interpreter.From do
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

  def from(namespace, specable, opts \\ [], env \\ %{})

  def from(namespace, {func, args}, opts, env) when is_atom(func) do
    max_demand = Keyword.get(opts, :max_demand, 1)
    min_demand = Keyword.get(opts, :min_demand, 0)
    stages = Keyword.get(opts, :stages, 1)
    window = Keyword.get(opts, :window, Flow.Window.global)
    key_fn = Keyword.get(opts, :key, &default_hash/1)

    {:ok, module} = Exd.Plugin.resolve({func, args})
    {:ok, calls} = module.handle_parse({func, args})
    {:ok, [result]} = module.handle_eval([calls])

    Flow.from_enumerable(result)
    |> Flow.map(&to_record(&1, namespace, key_fn))
    |> Flow.partition(
      stages: stages,
      min_demand: min_demand,
      max_demand: max_demand,
      key: &(&1.key)
    )
  end

  @doc """
  Creates a new flow from source
  """
  @spec from(binary(), any(), options()) :: Flow.t
  def from(namespace, specable, opts, env) do
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

    Exd.Specable.to_spec(specable, subscription_opts, env)
    |> Flow.map(&to_record(&1, namespace, key_fn))
    |> Flow.partition(
      stages: stages,
      min_demand: min_demand,
      max_demand: max_demand,
      key: &(&1.key)
    )
  end

  defp to_record(%ExdRecord{} = record, namespace, _key_fn) do
    ExdRecord.new(record.key, %{namespace => record.value}, pid: self())
  end
  defp to_record(value, namespace, key_fn) do
    key = key_fn.(%{namespace => value})
    ExdRecord.new(key, %{namespace => value}, pid: self())
  end

  # Uses the sha256 hash of the record to generate a new key
  defp default_hash(record) do
    :crypto.hash(:sha256, inspect(record))
    |> Base.encode16
    |> String.slice(0..16)
  end

end
