defmodule Exd.Runner.Select do
  @moduledoc """
  Select clause
  """
  alias Exd.Resolvable

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
    |> Flow.map(fn %Exd.Record{} = record ->
        selection
        |> Enum.reduce(%{}, fn {key, expr}, row ->
          resolved =
            case Exd.Resolvable.resolve(expr, record) do
              {_key, resolved} -> resolved
              resolved -> resolved
            end
          Map.put(row, key, resolved)
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

  # def select(flow, nil) do
  #   flow
  #   |> Flow.map(fn record ->
  #     Map.merge(record.value, %{"_key" => record.key})
  #   end)
  # end

end
