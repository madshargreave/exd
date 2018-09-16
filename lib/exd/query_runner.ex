defmodule Exd.QueryRunner do
  @moduledoc """
  Main flow coordinator
  """
  alias Exd.Query
  alias Exd.Runner.Planner

  @doc """
  Runs source flow

  ## Example

      Exd.Query{from: {"people", Person}, select: "people.name"}
      |> Exd.QueryRunner.stream(query)
      |> Enum.to_list
      ["mads", "jack"]
  """
  @spec stream(Query.queryable()) :: Flow.t()
  def stream(query) do
    Planner.plan(query)
  end

end
