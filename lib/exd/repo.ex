
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

  @doc """
  Runs the stream
  """
  def run(query, opts \\ []) do
    query
    |> stream()
    |> Stream.run
  end

  def start_link(query, opts \\ []) do
    query
    |> stream()
    |> Flow.start_link
  end

end
