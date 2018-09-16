defimpl Exd.Parseable, for: Map do
  alias Exd.Query

  @sources %{
    "list" => Exd.Source.List,
    "crawler" => Exd.Source.Crawler
  }

  @sinks %{
    "sql" => Exd.Sink.SQL,
    "logger" => Exd.Sink.Logger
  }

  def parse(map) do
    query =
      Query.new
      |> parse_from(map)
      |> parse_joins(map)
      |> parse_where(map)
      |> parse_select(map)
      |> parse_into(map)
    {:ok, query}
  end

  defp parse_from(query, %{
    "sources" => sources,
    "from" => %{
      "name" => from_name,
      "source" => from_source
    }
  }) do
    source = parse_source(query, Map.get(sources, from_source))
    Query.from(query, from_name, source)
  end

  defp parse_source(_query, %{
    "type" => type,
    "config" => config
  }) do
    module = parse_source_module(type)
    config = parse_source_config(config)
    {module, config}
  end
  defp parse_source(query, _), do: query
  defp parse_source_module(name), do: Map.fetch!(@sources, name)
  defp parse_source_config(config) when is_map(config) do
    for {key, value} <- config, into: [] do
      {String.to_atom(key), value}
    end
  end

  defp parse_joins(query, %{
    "sources" => sources,
    "joins" => joins
  }) do
    joins
    |> Enum.reduce(query, fn %{
      "type" => type,
      "from" => %{
        "name" => name,
        "source" => from_source
      },
      "left_key" => left_key,
      "right_key" => right_key
    }, acc ->
      type = String.to_atom(type)
      source = parse_source(query, Map.get(sources, from_source))
      Query.join(acc, type, name, source, left_key, right_key)
    end)
  end
  defp parse_joins(query, _), do: query

  defp parse_where(query, %{
    "where" => wheres
  }) do
    wheres
    |> Enum.reduce(query, fn %{
      "field" => field,
      "relation" => relation,
      "value" => value
    }, acc ->
      relation = parse_relation(relation)
      Query.where(acc, field, relation, value)
    end)
  end
  defp parse_where(query, _), do: query

  defp parse_relation("greater_than"), do: :>
  defp parse_relation("less_than"), do: :<
  defp parse_relation("is"), do: :=
  defp parse_relation("is_not"), do: :<>

  defp parse_select(query, %{
    "select" => select
  }) do
    Query.select(query, select)
  end

  defp parse_into(query, %{
    "into" => into,
  }) when is_list(into) do
    into
    |> Enum.reduce(query, fn %{
      "type" => type,
      "config" => config
    }, acc ->
      module = parse_into_module(type)
      config = parse_into_config(config)
      Query.into(acc, module, config)
    end)
  end
  defp parse_into(query, _), do: query
  defp parse_into_module(name), do: Map.fetch!(@sinks, name)
  defp parse_into_config(config) when is_map(config) do
    for {key, value} <- config, into: [] do
      {String.to_atom(key), value}
    end
  end

end
