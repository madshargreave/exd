defmodule Exd.Interpreter.Flatten do
  @moduledoc """
  Flattens a list into a stream of rows
  """

  def flatten(flow, keys) do
    keys
    |> Enum.reduce(flow, fn key, flow ->
      key = to_atom(key)

      flow
      |> Flow.flat_map(fn record ->
        for element <- Map.get(record.value, key), do: %Exd.Record{record | value: %{record.value | key => element}}
      end)
    end)
  end
  def flatten(flow, _selection), do: flow

  # defp to_atom(key) when is_binary(key), do: String.to_atom(key)
  defp to_atom(key) when is_atom(key), do: key


end
