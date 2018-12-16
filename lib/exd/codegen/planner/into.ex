defmodule Exd.Codegen.Planner.Into do
  @moduledoc false
  alias Exd.AST

  def plan(flow, %AST.SelectExpr{into: nil}), do: flow
  def plan(flow, %AST.SelectExpr{into: spec}) do
    specs = [{spec, []}]
    flow
    |> Flow.through_specs(specs)
  end

end
