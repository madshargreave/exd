defmodule Exd.Codegen.Planner.Into do
  @moduledoc false
  alias Exd.AST

  def plan(flow, %AST.SelectExpr{into: nil}, context), do: flow
  def plan(flow, %AST.SelectExpr{into: {module, args}}, context) do
    spec = {module, context}
    specs = [{spec, []}]
    flow
    |> Flow.through_specs(specs)
  end

end
