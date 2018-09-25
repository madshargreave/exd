defmodule Exd.Interpreter.Select do
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
          resolved = do_select(record, expr).value
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
    |> Flow.map(&do_select(&1, selection))
  end
  defp do_select(record, {:binding, binding, path} = expr), do: %Exd.Record{record | value: resolve_arg(record, expr)}
  defp do_select(record, {func, args} = expr) do
    args = for arg <- args, do: resolve_arg(record, arg)
    {:ok, module} = Exd.Plugin.resolve({func, args})
    {:ok, calls} = module.handle_parse({func, args})
    {:ok, [result]} = module.handle_eval([calls])
    %Exd.Record{record | value: result}
  end

  def resolve_arg(record, args) when is_list(args), do: for arg <- args, do: resolve_arg(record, arg)
  # def resolve_arg(record, {:binding, binding, path}) when is_list(path), do: get_in(record.value, [binding | path])
  def resolve_arg(record, {:binding, binding, nil}), do: get_in(record.value, [binding])
  def resolve_arg(record, {:binding, binding, path}) when is_list(path), do: get_in(record.value, [binding | path])
  def resolve_arg(record, {:binding, binding, path}), do: get_in(record.value, [binding | [path]])
  def resolve_arg(record, value) when is_binary(value), do: value
  def resolve_arg(record, %Regex{} = value), do: value
  def resolve_arg(record, value), do: value

end