
defmodule Exd.Repo do
  @moduledoc """
  Repository for sources
  """
  alias Exd.QueryRunner

  @doc """
  Returns a stream of sourced records
  """
  def stream(query, opts \\ []) do
    QueryRunner.stream(query)
  end

end
