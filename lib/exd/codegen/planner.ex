defmodule Exd.Codegen.Planner do
  @moduledoc """
  Plans query
  """
  alias Exd.AST
  alias Exd.Codegen.Planner.{From, Select, Into}

  def plan(%AST.Program{} = program) do
    plan(program.query)
  end

  def plan(%AST.Query{} = query) do
    flow =
      query.from
      |> From.plan()
      |> Select.plan(query.select)
      |> Into.plan(query.select)
  end

end
