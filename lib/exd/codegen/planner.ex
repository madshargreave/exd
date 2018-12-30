defmodule Exd.Codegen.Planner do
  @moduledoc """
  Plans query
  """
  alias Exd.AST
  alias Exd.Codegen.Planner.{From, Select, Into, GroupBy}

  def plan(program, meta \\ [])
  def plan(%AST.Program{} = program, meta) do
    context =
      %Exd.Context{
        env: meta
      }
    flow =
      program.query.from
      |> From.plan(program.ctes, context)
      |> GroupBy.plan(program.query.group_by, context)
      |> Select.plan(program.query.select, context)
      |> Into.plan(program.query.select, context)
  end

  def plan(%AST.Query{} = query, context) do
    flow =
      query.from
      |> From.plan(context)
      |> Select.plan(query.select, context)
  end

end
