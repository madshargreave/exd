defmodule Exd.Codegen.Planner.Select do
  @moduledoc false
  alias Exd.AST

  def plan(flow, %AST.SelectExpr{} = select) do
    flow
    |> Flow.map(fn record ->
      select.columns
      |> Enum.with_index
      |> Enum.reduce(%{}, fn {%AST.ColumnExpr{} = column, index}, acc ->
        value = select_value(column.expr, record)
        if column.name do
          Map.put(acc, column.name.value, value)
        else
          Map.put(acc, "f_#{index}", value)
        end
      end)
    end)
  end

  defp select_value(%AST.ColumnRef{family: nil, all: true} = binding, record),
    do: record.value
  defp select_value(%AST.ColumnRef{family: family, all: true} = binding, record),
    do: Map.get(record.value, family)
  defp select_value(%AST.BindingExpr{family: nil} = binding, record),
    do: get_in(record.value, [binding.identifier.value])
  defp select_value(%AST.BindingExpr{family: family, identifier: nil} = binding, record) when is_binary(family),
    do: get_in(record.value, [binding.family])
  defp select_value(%AST.BindingExpr{} = binding, record),
    do: get_in(record.value, [binding.family, binding.identifier])
  defp select_value(%AST.NumberLiteral{} = literal, record),
    do: literal.value
  defp select_value(%AST.StringLiteral{} = literal, record),
    do: literal.value

  defp select_value(%AST.CallExpr{} = call, record) do
    args = for arg <- call.arguments, do: select_value(arg, record)
  end

end
