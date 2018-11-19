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

  def select(flow, :select_all, env) do
    flow
    |> Flow.map(fn record ->
        value =
          record.value
          |> Map.keys()
          |> Enum.reduce(%{}, fn key, acc ->
            value = Map.get(record.value, key)
            if is_map(value) do
              Map.merge(value, acc)
            else
              value
            end
          end)
        %Exd.Record{record | value: value}
    end)
  end

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
      %Exd.Record{record | value: AtomicMap.convert(value, %{ignore: true, safe: false})}
    end)
  end

  @doc """
  Selects tuple
  """
  def select(flow, selection, env) when is_tuple(selection) do
    flow
    |> Flow.map(&do_select(&1, selection))
  end
  defp do_select(record, {:binding, [binding | path]} = expr), do: %Exd.Record{record | value: resolve_arg(record, expr)}
  defp do_select(record, {func, args} = expr) do
    args = for arg <- args, do: resolve_arg(record, arg)
    {:ok, module} = Exd.Plugin.resolve({func, args})
    {:ok, calls} = module.handle_parse({func, args})
    case module.handle_eval([calls]) do
      {:ok, [result]} ->
        %Exd.Record{record | value: result}
      {:ok, result} ->
        %Exd.Record{record | value: result}
    end
  end

  def resolve_arg(record, args) when is_list(args), do: for arg <- args, do: resolve_arg(record, arg)
  def resolve_arg(record, {:binding, binding}), do: get_in(AtomicMap.convert(record.value, %{ignore: true, safe: false}), binding)
  def resolve_arg(record, value) when is_binary(value), do: value
  def resolve_arg(record, value) when is_atom(value), do: value
  def resolve_arg(record, %Regex{} = value), do: value
  def resolve_arg(record, {:sigil_r, [{:<<>>, [regex]}, []]}), do: Regex.compile!(regex)
  def resolve_arg(record, value) when is_integer(value), do: value
  def resolve_arg(record, value), do: do_select(record, value).value

  # defp atom_to_string(binding) when is_atom(binding), do: Atom.to_string(binding)
  # defp atom_to_string(binding), do: binding

end
