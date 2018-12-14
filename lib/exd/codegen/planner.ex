defmodule Exd.Codegen.Planner do
  @moduledoc """
  Plans query
  """
  alias Exd.AST
  alias Exd.Codegen.Planner.{From, Select}

  def plan(%AST.Program{} = program) do
    plan(program.query)
  end

  def plan(%AST.Query{} = query) do
    flow =
      query.from
      |> From.from()
      |> Select.select(query.select)
  end

end
