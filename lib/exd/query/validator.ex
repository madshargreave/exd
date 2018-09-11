defmodule Exd.Query.Validator do
  @moduledoc false
  require Logger

  @doc """
  Validates if a data structures can be parsed as an `Exd.Query`
  """
  def validate(queryable) do
    Exd.Parseable.parse(queryable)
  # rescue
  #   exception ->
  #     Logger.error "Failed to parse query:\n#{inspect exception}"
  #     {:error, :invalid_query}
  end

end
