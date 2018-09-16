defimpl Exd.Parseable, for: Exd.Query do
  def parse(queryable) do
    {:ok, queryable}
  end
end
