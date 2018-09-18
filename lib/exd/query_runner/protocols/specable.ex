defprotocol Exd.Specable do
  @moduledoc """
  Transform Elixir primitive types into source and sink specs
  """

  def to_spec(specable, subscription_opts \\ [])

end

alias Exd.Source.Function, as: SourceFunction
alias Exd.Source.List, as: SourceList

defimpl Exd.Specable, for: List do
  def to_spec(list, subscription_opts \\ [])

  def to_spec([%Exd.Query{} = first | _rest] = subqueries, subscription_opts) do
    subqueries
    |> Enum.map(&Exd.Specable.to_spec(&1, subscription_opts))
    |> Flow.merge(GenStage.DemandDispatcher, stages: 1)
  end

  def to_spec(list, subscription_opts) do
    adapter_spec = {
      SourceList,
        value: list
    }

    source_opts = [adapter: adapter_spec]
    specs = [{Exd.Source, source_opts}]

    specs
    |> Flow.from_specs(subscription_opts)
  end
end

defimpl Exd.Specable, for: Function do
  def to_spec(func, subscription_opts \\ []) do
    adapter_spec = {
      SourceFunction,
        fn: func
    }

    source_opts = [adapter: adapter_spec]
    specs = [{Exd.Source, source_opts}]

    specs
    |> Flow.from_specs(subscription_opts)
  end
end

defimpl Exd.Specable, for: Exd.Query do
  def to_spec(%{from: {namespace, specable, _}} = _query, subscription_opts \\ []) do
    Exd.Runner.From.from(namespace, specable, subscription_opts)
    |> Exd.Runner.Select.select(namespace)
  end
end

defimpl Exd.Specable, for: Tuple do
  def to_spec(spec, subscription_opts \\ [])
  def to_spec({module, args} = spec, subscription_opts) when is_atom(module) and is_list(args) do
    source_opts = [adapter: spec]
    specs = [{Exd.Source, source_opts}]

    specs
    |> Flow.from_specs(subscription_opts)
  end
  def to_spec(func_and_args, subscription_opts) do
    func_and_args
    |> Exd.Resolvable.resolve(%Exd.Record{})
    |> Flow.from_enumerable
  end
end


defimpl Exd.Specable, for: PID do
  def to_spec(pid, subscription_opts \\ []) do
    Flow.from_stage(pid)
  end
end
