defprotocol Exd.Sourceable do
  @moduledoc """
  Protocol defining datastructures that can be used as a source
  """
  def source(sourceable, context)
  def into(sourceable, documents)
end

defimpl Exd.Sourceable, for: List do
  def source([%Exd.Query{} | _rest] = queries, context) do
    queries
    |> Enum.map(&Exd.QueryRunner.stream/1)
    |> Flow.merge(GenStage.DemandDispatcher, stages: 1)
  end
  def source(list, context) do
    Flow.from_enumerable(list)
  end
  # def into([first | _rest] = sinks, flow) when is_tuple(first) do
    # sinks
    # |> Enum.reduce(flow, fn sink, flow ->
      # Exd.Sourceable.into(sink, flow)
    # end)
  # end
end

defimpl Exd.Sourceable, for: Tuple do
  def source({source, args} = spec, context) when is_atom(source) do
    subscription_opts = [stages: 1, max_demand: 1]
    args = Keyword.put(args, :adapter, {source, args})
    specs =  [%{start: {Exd.Source, :start_link, [args]}}]
    Flow.from_specs(specs, subscription_opts)
  end
  def into({sink, args}, flow) when is_atom(sink) do
    args = Keyword.put(args, :adapter, {sink, args})
    spec = {Exd.Sink, args}
    subscription_opts = Keyword.take(args, [:max_demand, :min_demand])
    specs =  [{spec, subscription_opts}]
    Flow.through_specs(flow, specs)
  end
end

defimpl Exd.Sourceable, for: Function do
  def source(function, context) do
    function.(context)
    |> Exd.Sourceable.source(context)
  end
  def into(function, documents) do
    function.(documents)
  end
end

defimpl Exd.Sourceable, for: Atom do
  def source(module, context) do
    {provider, opts} = module.__source__(:provider)
    opts = [stages: 1, max_demand: 1]
    specs = [%{start: {module, :start_link, [context]}}]

    # IO.inspect module
    # case Process.whereis(module) do
      # nil ->
        Flow.from_specs(specs, opts)
      # _ ->
        # Flow.from_stages(specs, opts)
    # end
  rescue
    UndefinedFunctionError ->
      message =
        if :code.is_loaded(module) do
          "the given module does not provide a schema"
        else
          "the given module does not exist"
        end

      raise Protocol.UndefinedError,
        protocol: @protocol, value: module, description: message
  end

  def into(module, documents) do
    module.insert(documents)
  end
end

defimpl Exd.Sourceable, for: Exd.Query do
  def source(query, context) do
    Exd.QueryRunner.stream(query)
  end
end

defimpl Exd.Sourceable, for: PID do
  def source(pid, context) do
    [pid]
    |> Flow.from_stages
  end
end
