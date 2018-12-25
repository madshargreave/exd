
defmodule Exd.Repo do
  @moduledoc """
  Repository for sources
  """
  alias Exd.Interpreter

  defmodule Doubler do
    use GenStage

    def start_link(opts) do
      GenStage.start_link(__MODULE__, opts)
    end

    def init(_) do
      {:consumer, []}
    end

    def handle_events(events, _from, state) do
      {:noreply, [], state}
    end

  end

  @doc """
  Returns a stream of sourced records
  """
  def stream(query, opts \\ []) do
    query
    |> Exd.Codegen.Planner.plan
  end

  @doc """
  Runs the stream
  """
  def run(query, opts \\ []) do
    query
    |> Exd.Codegen.Planner.plan(opts)
    |> Enum.to_list
  end

  @doc """
  Runs the stream
  """
  def all(query, opts \\ []) do
    query
    |> run(opts)
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
    # |> Flow.start_link
  end

end
