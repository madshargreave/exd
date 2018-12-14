defmodule Exd.Codegen.Planner.Select do
  @moduledoc false
  alias Exd.AST

  def select(flow, %AST.SelectExpr{} = select) do
    flow
    |> Flow.map(fn record ->
      select.columns
      |> Enum.reduce(%{}, fn %AST.ColumnExpr{} = column, acc ->
        value = select_value(column.expr, record)
        Map.put(acc, column.name, value)
      end)
    end)
  end

  defp select_value(%AST.BindingExpr{family: nil} = binding, record), do:
    get_in(record.value, [binding.identifier])
  defp select_value(%AST.BindingExpr{family: family, identifier: nil} = binding, record) when is_binary(family), do:
    get_in(record.value, [binding.family])
  defp select_value(%AST.BindingExpr{} = binding, record), do:
    get_in(record.value, [binding.family, binding.identifier])
  defp select_value(%AST.NumberLiteral{} = literal, record), do:
    literal.value
  defp select_value(%AST.StringLiteral{} = literal, record), do:
    literal.value

  defp select_value(%AST.CallExpr{} = call, record) do
    args = for arg <- call.arguments, do: select_value(arg, record)
  end

end
