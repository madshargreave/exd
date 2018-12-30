defmodule Exd.Codegen.Evaluator do
  @moduledoc """
  Evaluates contextual expressions
  """
  require Logger
  alias Exd.{Record, Plugin, AST, Window}

  @analytical_functions ~w(sum avg count)

  def eval(record,  %AST.CallExpr{identifier: %AST.Identifier{value: "unnest"}} = call) do
    [source_expr] = call.params
    eval(record, source_expr)
  end
  def eval(record,  %AST.CallExpr{identifier: %AST.Identifier{value: name}} = call)
    when name in @analytical_functions
  do
    eval_group(call.identifier.value, record)
  end
  def eval(context, %AST.CallExpr{} = call) do
    params = Enum.map(call.params, &eval(context, &1))
    {:ok, plugin} = Plugin.find(call.identifier.value)
    {:ok, event} = plugin.eval(params)
    event
  end
  def eval(context, exprs) when is_list(exprs),
    do: for expr <- exprs, do: eval(context, expr)
  def eval(context, %AST.ColumnRef{family: nil, all: true} = binding),
    do: context
  def eval(context, %AST.ColumnRef{family: family, all: true} = binding),
    do: Map.get(context, family.value)
  def eval(context, %AST.ColumnRef{family: nil, column_name: column_name, all: false} = binding),
    do: Map.get(context, column_name.value)
  def eval(context, %AST.ColumnRef{family: family, column_name: name, all: false} = binding),
    do: get_in(context, [family.value, name.value])
  def eval(context, %AST.BindingExpr{family: nil} = binding),
    do: get_in(context, [binding.identifier.value])
  def eval(context, %AST.BindingExpr{family: family, identifier: nil} = binding) when is_binary(family),
    do: get_in(context, [binding.family])
  def eval(context, %AST.BindingExpr{} = binding),
    do: get_in(context, [binding.family, binding.identifier])
  def eval(context, %AST.NumberLiteral{} = literal),
    do: literal.value
  def eval(context, %AST.StringLiteral{} = literal),
    do: literal.value
  def eval(_, expr) do
    Logger.error "Could not find matching clause for expression: #{inspect expr}"
    :error
  end

  defp eval_group(record, %AST.CallExpr{identifier: %AST.Identifier{value: "sum"}, params: [arg]} = call) do
    %{value: value} = WindowStore.get(record.window)
    next_value = value + eval(record.value, arg)
    WindowStore.save(record.window, next_value)
  end

end
