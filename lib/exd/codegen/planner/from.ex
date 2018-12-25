defmodule Exd.Codegen.Planner.From do
  @moduledoc false
  alias Exd.AST
  alias Exd.Codegen.Evaluator

  @functions ~w(range fetch)

  def plan(%AST.TableExpr{expr: [%AST.NumberLiteral{} | _rest]} = from, context) do
    from.expr
    |> Enum.map(&%Exd.Record{value: %{from.name.value => &1.value}})
    |> Flow.from_enumerable(stages: 1)
  end

  def plan(%AST.TableExpr{
    name: name,
    expr: %AST.CallExpr{
      identifier: %AST.Identifier{value: caller},
      params: params
    },
  },
  context) when caller in @functions
  do
    {:ok, plugin} = Exd.Plugin.find(caller)
    params = Evaluator.eval(%Exd.Record{}, params)
    context = %Exd.Context{context | params: params}
    specs = [{plugin, context}]

    Flow.from_specs(specs, stages: 1)
    |> Flow.map(fn record -> %Exd.Record{record | value: %{name.value => record.value}} end)
  end

  defp to_record(nil, value),
    do: %Exd.Record{value: value}
  defp to_record(%AST.Identifier{value: name}, value),
    do: %Exd.Record{value: %{name => value}}

end
