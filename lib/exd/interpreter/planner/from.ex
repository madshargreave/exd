defmodule Exd.Interpreter.From do
  @moduledoc """
  From clause
  """
  alias Exd.Record
  alias Exd.Query
  alias Exd.Interpreter.Planner

  @doc """
  Creates a flow from source and wraps it in binded scope
  """
  def from(binding, specable, opts \\ [], env \\ %{})
  def from(binding, {:subquery, [%Query{} = query]}, opts, env) do
    from(binding, Planner.plan_query(query), opts, env)
  end
  def from(binding, {identifier, args} = expr, opts, env)
    when is_atom(identifier) and is_list(args)
  do
    with {:ok, module} <- Exd.Plugin.resolve(expr),
         {:ok, {module, opts} = spec} <- module.handle_parse(expr) do
      opts = Keyword.merge(opts, source: true)
      spec = {module, opts}
      flow =
        args
        |> Flow.from_enumerable(stages: 1, max_demand: 1)
        |> Flow.through_specs([{spec, []}], stages: 1)

      from(binding, flow, opts, env)
    end
  end
  def from(binding, source, opts, env) when is_list(source) do
    from(binding, Flow.from_enumerable(source), opts, env)
  end
  def from(binding, %Stream{} = source, opts, env) do
    from(binding, Flow.from_enumerable(source), opts, env)
  end
  def from(binding, %Flow{} = flow, opts, env) do
    max_demand = Keyword.get(opts, :max_demand, 1)
    min_demand = Keyword.get(opts, :min_demand, 0)
    stages = Keyword.get(opts, :stages, 1)
    window = Keyword.get(opts, :window, Flow.Window.global)
    key_fn = Keyword.get(opts, :key, &default_hash/1)

    flow
    |> Flow.map(&to_record(&1, binding, key_fn))
    |> Flow.partition(
      stages: stages,
      min_demand: min_demand,
      max_demand: max_demand,
      key: &(&1.key)
    )
  end

  # Wrap the record in the binding
  defp to_record(%Record{} = record, binding, _key_fn) do
    %Record{record | value: %{binding => record.value}}
  end
  defp to_record(value, binding, key_fn) do
    key = key_fn.(%{binding => value})
    Record.new(key, %{binding => value})
  end

  # Uses the sha256 hash of the record to generate a new key
  defp default_hash(record) do
    :crypto.hash(:sha256, inspect(record))
    |> Base.encode16
    |> String.slice(0..16)
  end

end
