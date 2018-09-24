defmodule Exd.Interpreter.Into do
  @moduledoc """
  Select clause
  """

  @doc """
  Resolves select statement
  """
  @spec into(Flow.t(), tuple()) :: Flow.t()
  def into(flow, sink) do
    sink_opts = [adapter: sink]
    spec = {Exd.Sink, sink_opts}
    subscription_opts = []
    specs = [{spec, subscription_opts}]
    Flow.through_specs(flow, specs)
  end

end
