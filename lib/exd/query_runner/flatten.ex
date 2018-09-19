defmodule Exd.Runner.Flatten do
  @moduledoc """
  Flattens a list into a stream of rows
  """

  def flatten(flow, selection) when is_map(selection) do
    selection
    |> Enum.reduce(flow, fn {key, expr}, flow ->
      case expr do
        {:unnest, _} ->
          flow
          |> Flow.flat_map(fn record ->
            for element <- Map.get(record, key), do: %{record | key => element}
          end)
        _ ->
          flow
      end
    end)
  end
  def flatten(flow, _selection), do: flow

end
