defmodule Exd.Codegen.Planner.Select do
  @moduledoc false
  use GenStage

  alias Exd.{AST, Plugin, Record}
  alias Exd.Codegen.Evaluator

  def plan(flow, %AST.SelectExpr{} = select, context) do
    {flow, keys} =
      select.columns
      |> Enum.reduce({flow, []}, fn column, {acc, keys} ->
        column_names = AST.ColumnExpr.names(column)
        if length(column_names) > 0 do
          {do_plan(acc, column), keys ++ column_names}
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
        %AST.ColumnExpr{names: names, expr: %AST.CallExpr{identifier: %AST.Identifier{value: "unnest"}}} = column ->
          names = AST.ColumnExpr.names(column)
          record.value
          |> Evaluator.eval(column.expr)
          |> Enum.zip
          |> Enum.map(fn values ->
            values
            |> Tuple.to_list
            |> Enum.with_index
            |> Enum.reduce(%Record{}, fn {value, index}, acc ->
              Record.from(acc, %{
                Enum.at(names, index) => value
              })
            end)
          end)
        %AST.ColumnExpr{names: [%AST.Identifier{value: name}]} ->
          Record.from(record, %{
            name => Evaluator.eval(record.value, column.expr)
          })
        %AST.ColumnExpr{names: [], expr: %AST.ColumnRef{column_name: %AST.Identifier{value: name}}} ->
          Record.from(record, %{
            name => Evaluator.eval(record.value, column.expr)
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
