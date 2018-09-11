defmodule Exd.QueryRunner do
  @moduledoc """
  Main flow coordinator
  """
  alias Exd.Query
  alias Exd.Sourceable

  @stages 3
  @max_demand 10

  @doc """
  Runs source flow

  ## Example

      Exd.Query{from: {"people", Person}, select: "people.name"}
      |> Exd.QueryRunner.stream(query)
      |> Enum.to_list
      ["mads", "jack"]
  """
  @spec stream(Query.queryable()) :: Flow.t()
  def stream(%Query{from: {name, sourceable}} = query) do
    window = Flow.Window.count(5)
    wrap_name = fn document -> if is_map(document), do: %{ name => document }, else: document end

    sourceable
    |> Sourceable.source([])
    |> Flow.map(wrap_name)
    |> Flow.partition(stages: 1, max_demand: 1, window: window)
    |> Flow.reduce(fn -> [] end, fn document, acc -> [document | acc] end)
    |> Flow.on_trigger(&{[&1],[]})
    |> Flow.partition(stages: 1, max_demand: 1, window: Flow.Window.periodic(1, :second))
    |> Flow.reject(fn events -> length(events) == 0 end)
    |> resolve_joins(query)
    # |> Flow.flat_map(&resolve_joins(query, &1))
    |> Flow.flat_map(&resolve_where(query, &1))
    |> Flow.uniq_by(&resolve_distinct(query, &1))
    |> Flow.map(&resolve_select(query, &1))
    |> Flow.each(&resolve_materialize(query, &1))
    |> resolve_into(query)
  end

  defp resolve_joins(flow, %{joins: joins} = query) do
    joins
    |> Enum.reduce(flow, fn %{from: {name, {source, args}}} = join, flow ->
      IO.inspect join
      subscription_opts = [stages: 1, max_demand: 1]
      args = Keyword.put(args, :adapter, {source, args})
      specs =  [%{start: {Exd.Source, :start_link, [{:mode, :producer_consumer} | args]}}]
      Flow.through_specs(flow, specs, subscription_opts)
    end)
  end

  # @doc """
  # Resolves join expressions
  # """
  # defp resolve_joins(%{from: {name, _source_spec}, joins: joins} = query, documents) do
  #   inner = Flow.from_enumerable(documents)

  #   joins
  #   |> Enum.reduce(inner, &resolve_join(&1, &2, documents))
  #   |> Enum.to_list()
  # end
  # defp resolve_joins(%{from: {name, _source_spec}} = query, documents), do: documents

  # defp resolve_join(%{from: {name, source}} = join, left_flow, documents) do
  #   right_flow =
  #     source
  #     |> Sourceable.source(documents)
  #     |> Flow.map(fn doc -> %{ name => doc } end)

  #   Flow.bounded_join(
  #     join.type,
  #     left_flow,
  #     right_flow,
  #     &Kernel.get_in(&1, String.split(join.left_key, ".")),
  #     &Kernel.get_in(&1, String.split(join.right_key, ".")),
  #     fn left, right ->
  #       Map.merge(left, right || %{})
  #     end
  #   )
  # end

  defp resolve_distinct(%Query{distinct: nil} = query, document), do: document
  defp resolve_distinct(%Query{distinct: distinct} = query, document) do
    path = String.split(distinct, ".")
    Kernel.get_in(document, path)
  end

  @spec resolve_select(atom() | %{select: any()}, any()) :: any()
  def resolve_select(%Query{select: nil} = _query, document) when is_map(document) do
    document
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      Map.merge(acc, value)
    end)
  end
  def resolve_select(%Query{select: select} = query, document) when is_tuple(select) do
    select
    |> Tuple.to_list
    |> Enum.map(fn path_as_string ->
      path = String.split(path_as_string, ".")
      Kernel.get_in(document, path)
    end)
    |> List.to_tuple
  end
  def resolve_select(%Query{select: select} = query, document) when is_map(select) do
    query.select
    |> Enum.reduce(%{}, fn {key, path}, acc ->
      # IO.inspect path
      value =
        cond do
          String.contains?(path, "'") ->
            String.replace(path, ~r/\'/, "", global: true)
          String.contains?(path, "-") ->
            [left, right] = String.split(path, "-") |> Enum.map(&String.trim/1)
            left_path_as_list = String.split(left, ".")
            left_value = Kernel.get_in(document, left_path_as_list)

            right_path_as_list = String.split(right, ".")
            right_value = Kernel.get_in(document, right_path_as_list)

            Float.round(left_value - right_value, 2)
          true ->
            path_as_list = String.split(path, ".")
            Kernel.get_in(document, path_as_list)
        end
      Map.put(acc, key, value)
    end)
  end
  def resolve_select(_, document), do: document

  defp resolve_where(%Query{where: nil} = _query, document), do: [document]
  defp resolve_where(query, document) do
    match? =
      query.where
      |> Enum.all?(fn {field, relation, value} ->
        left_path_as_list = String.split(field, ".")
        left_value = Kernel.get_in(document, left_path_as_list)

        right_is_quoted = is_binary(value) && String.contains?(value, "'")
        right_path_as_list = is_binary(value) && String.split(value, ".")
        right_value =
          cond do
            right_is_quoted ->
              String.replace(value, ~r/\'/, "", global: true)
            is_integer(value) ->
              value
            true ->
              if value, do: Kernel.get_in(document, right_path_as_list), else: nil
          end

        case relation do
          := -> left_value == right_value
          :> -> left_value > right_value
          :<> -> left_value != right_value
        end
      end)
    if match?, do: [document], else: []
  end

  defp resolve_materialize(%Query{materialize: nil} = query, documents), do: documents
  defp resolve_materialize(%Query{materialize: materialize} = query, document) do
    document
  end

  defp resolve_into(flow, %Query{into: nil} = query), do: flow
  defp resolve_into(flow, %Query{into: into} = query) do
    Exd.Sourceable.into(into, flow)
  end

end
