defimpl Exd.Parseable, for: Map do
  alias Exd.Query

  def parse(map) do
    query =
      Query.new
      |> parse_from(map)
      |> parse_where(map)
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

  defp parse_source(query, %{
    "type" => "list",
    "config" => %{
      "value" => value
    }
  }) do
    {Exd.Source.List, value: value}
  end

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

end
