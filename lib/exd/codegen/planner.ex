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
    plan(program.query, context)
  end

  def plan(%AST.Query{} = query, meta) do
    context =
      %Exd.Context{
        env: meta
      }
    flow =
      query.from
      |> From.plan(context)
      |> GroupBy.plan(query.group_by, context)
      |> Select.plan(query.select, context)
      |> Into.plan(query.select, context)
  end

end
