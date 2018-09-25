defprotocol Exd.Specable do
  @moduledoc """
  Transform Elixir primitive types into source and sink specs
  """

  def to_spec(specable, subscription_opts \\ [], env \\ %{})

end

alias Exd.Source.Function, as: SourceFunction
alias Exd.Source.List, as: SourceList

defimpl Exd.Specable, for: List do
  def to_spec(list, subscription_opts \\ [], env \\ %{}) do
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
  def to_spec(func, subscription_opts \\ [], env \\ %{}) do
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
  def to_spec(query, subscription_opts, env \\ %{}) do
    Exd.Interpreter.Planner.plan_query(query)
  end
end

defimpl Exd.Specable, for: Tuple do
  def to_spec(func_and_args, subscription_opts, env \\ %{}) do
    Exd.Resolvable.resolve(func_and_args, env)
    |> Flow.from_enumerable
    # with {:ok, module} <- Exd.Plugin.resolve(func_and_args),
        #  {:ok, invocation} <- module.handle_parse(func_and_args),
        #  invocation = Exd.Resolvable.resolve(invocation, %Exd.Record{}, env),
        #  IO.inspect(invocation),
        #  {:ok, produced} <- module.handle_eval([invocation]) do
      # Flow.from_enumerables(produced)
    # end
  end
end

defimpl Exd.Specable, for: PID do
  def to_spec(pid, subscription_opts \\ [], env \\ %{}) do
    Flow.from_stage(pid)
  end
end
