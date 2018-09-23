
defmodule Exd.Repo do
  @moduledoc """
  Repository for sources
  """
  alias Exd.QueryRunner

  @doc """
  Returns a stream of sourced records
  """
  def stream(query, opts \\ []) do
    query
    |> QueryRunner.stream
  end

  @doc """
  Runs the stream
  """
  def run(query, opts \\ []) do
    query
    |> stream()
    |> Enum.to_list
  end

  @doc """
  Runs the stream
  """
  def all(query, opts \\ []) do
    query |> run(opts)
  end

  @doc """
  Returns first matching result
  """
  def first(query, opts \\ []) do
    query
    |> run(opts)
    |> List.first
  end

  def start_link(query, opts \\ []) do
    query
    |> stream()
    |> Flow.start_link
  end

end
