defmodule Exd.Runner.Flatten do
  @moduledoc """
  Flattens a list into a stream of rows
  """

  def flatten(flow, keys) do
    keys
    |> Enum.reduce(flow, fn key, flow ->
      flow
      |> Flow.flat_map(fn record ->
        for element <- Map.get(record.value, key), do: %Exd.Record{record | value: %{record.value | key => element}}
      end)
    end)
  end
  def flatten(flow, _selection), do: flow

end
