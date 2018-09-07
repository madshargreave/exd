defmodule Exd.Query.Validator do
  @moduledoc false

  @doc """
  Validates if a data structures can be parsed as an `Exd.Query`
  """
  def validate(queryable) do
    Exd.Parseable.parse(queryable)
  rescue
    _exception ->
      {:error, :invalid_query}
  end

end
