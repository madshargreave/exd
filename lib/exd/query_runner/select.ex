defmodule Exd.Runner.Select do
  @moduledoc """
  Select clause
  """

  @doc """
  Resolves select statement
  """
  @spec select(Flow.t, map() | tuple()) :: Flow.t
  def select(flow, map_or_tuple)

  @doc """
  Selects map
  """
  def select(flow, selection) when is_map(selection) do
    flow
      |> Flow.map(fn record ->
        selection
        |> Enum.reduce(%{}, fn {key, path}, acc ->
          resolved = Exd.Resolvable.resolve(path, record)
          Map.put(acc, key, resolved)
        end)
      end)
  end

  @doc """
  Selects tuple
  """
  def select(flow, selection) when is_tuple(selection) do
    flow
    |> Flow.map(fn record ->
      selection
      |> Tuple.to_list
      |> Enum.map(fn path ->
        resolved = Exd.Resolvable.resolve(path, record)
        resolved
      end)
      |> List.to_tuple
    end)
  end

  def select(flow, selection) when is_binary(selection) do
    flow
    |> Flow.map(fn record ->
      Exd.Resolvable.resolve(selection, record)
    end)
  end

end
