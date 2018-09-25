defmodule Exd.Interpreter do
  @moduledoc """
  Main flow coordinator
  """
  alias Exd.Query
  alias Exd.Query.Rewriter
  alias Exd.Interpreter.Planner

  @doc """
  Runs source flow

  ## Example

      Exd.Query{from: {"people", Person}, select: "people.name"}
      |> Exd.Interpreter.stream(query)
      |> Enum.to_list
      ["mads", "jack"]
  """
  @spec stream(Query.queryable()) :: Flow.t()
  def stream(query) do
    flow =
      query
      |> Planner.plan
  end

end
