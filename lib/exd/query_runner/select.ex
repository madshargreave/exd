defmodule Exd.Runner.Select do
  @moduledoc """
  Select clause
  """

  @doc """
  Resolves select statement
  """
  @spec select(Flow.t, map()) :: Flow.t
  def select(flow, selection) do
    flow
    |> Flow.map(fn record ->
      selection
      |> Enum.reduce(%{}, fn {key, path}, acc ->
        resolved = Exd.Selectable.resolve(path, record)
        Map.put(acc, key, resolved)
      end)
    end)
  end

end
