defmodule Exd.Runner.Select do
  @moduledoc """
  Select clause
  """
  alias Exd.Resolvable

  @doc """
  Resolves select statement
  """
  @spec select(Flow.t, map() | tuple()) :: Flow.t
  def select(flow, map_or_tuple, env \\ %{})

  @doc """
  Selects map
  """
  def select(flow, selection, env) when is_map(selection) do
    flow
    |> Flow.map(fn %Exd.Record{} = record ->
      value =
        selection
        |> Enum.reduce(%{}, fn {key, expr}, row ->
          resolved =
            case Exd.Resolvable.resolve(expr, record, env) do
              {_key, resolved} -> resolved
              resolved -> resolved
            end
          Map.put(row, key, resolved)
        end)
      %Exd.Record{record | value: value}
    end)
  end

  @doc """
  Selects tuple
  """
  def select(flow, selection, env) when is_tuple(selection) do
    flow
    |> Flow.map(fn record ->
      value =
        selection
        |> Tuple.to_list
        |> Enum.map(fn path ->
          resolved = Exd.Resolvable.resolve(path, record)
          resolved
        end)
        |> List.to_tuple

      %Exd.Record{record | value: value}
    end)
  end

  def select(flow, namespace, env) when is_binary(namespace) do
    flow
    |> Flow.map(fn record ->
      value = Exd.Resolvable.resolve(namespace, record)
      %Exd.Record{record | value: value}
    end)
  end

  def select(flow, [first | _rest] = selection, env) when is_binary(first) do
    flow
    |> Flow.map(fn record ->
      value =
        selection
        |> Enum.reduce(%{}, fn namespace, acc ->
            acc
            |> Map.merge(Exd.Resolvable.resolve(namespace, record))
        end)
      %Exd.Record{record | value: value}
    end)
  end

end
