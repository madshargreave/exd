defmodule Exd.Codegen.Planner.GroupBy do
  @moduledoc false
  alias Exd.{Record, AST}
  alias Exd.Windows.TumblingWindow

  def plan(flow, nil, context), do: flow
  def plan(flow, %AST.GroupByExpr{columns: columns, window: window}, context) do
    Flow.map(flow, fn record ->
      %Record{record | group_by: columns, window: window}
    end)
  end

end
