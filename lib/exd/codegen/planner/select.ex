defmodule Exd.Codegen.Planner.Select do
  @moduledoc false
  use GenStage

  alias Exd.{AST, Plugin, Record}
  alias Exd.Codegen.Evaluator

  def plan(flow, %AST.SelectExpr{} = select, context) do
    {flow, keys} =
      select.columns
      |> Enum.reduce({flow, []}, fn column, {acc, keys} ->
        column_name = AST.ColumnExpr.name(column)
        if column_name do
          {do_plan(acc, column), keys ++ [column_name]}
        else
          {do_plan(acc, column), keys}
        end
      end)

    keys_with_all = ["all" | keys]
    flow
    |> Flow.map(&Map.take(&1.value, keys_with_all))
    |> Flow.map(fn value ->
      case value do
        %{"all" => all} ->
          value = Map.delete(value, "all")
          Map.merge(value, all)
        _ ->
          value
      end
    end)
  end

  defp do_plan(flow, %AST.ColumnExpr{} = column) do
    Flow.flat_map(flow, fn record ->
      case column do
        %AST.ColumnExpr{name: name, expr: %AST.CallExpr{identifier: %AST.Identifier{value: "unnest"}}} ->
          for value <- Evaluator.eval(record.value, column.expr) do
            Record.from(record, %{
              name.value => value
            })
          end
        %AST.ColumnExpr{name: %AST.Identifier{value: name}} ->
          Record.from(record, %{
            name => Evaluator.eval(record.value, column.expr)
          })
        %AST.ColumnExpr{name: nil, expr: %AST.ColumnRef{column_name: %AST.Identifier{value: name}}} ->
          Record.from(record, %{
            AST.ColumnExpr.name(column) => Evaluator.eval(record.value, column.expr)
          })
        _ ->
          Record.from(record, %{"all" => Evaluator.eval(record.value, column.expr)})
      end
      |> wrap_if_not_list
    end)
  end

  defp wrap_if_not_list(records) when is_list(records), do: records
  defp wrap_if_not_list(record), do: [record]

end
