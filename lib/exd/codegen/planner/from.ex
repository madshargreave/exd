defmodule Exd.Codegen.Planner.From do
  @moduledoc false
  alias Exd.AST
  alias Exd.Codegen.{Planner, Evaluator}

  @functions ~w(range fetch)

  def plan(%AST.TableExpr{expr: [%AST.NumberLiteral{} | _rest]} = from, _, context) do
    values = for literal <- from.expr, do: Evaluator.eval(%Exd.Record{}, literal)
    record = %Exd.Record{value: %{from.name.value => values}}
    Flow.from_enumerable([record], stages: 1)
  end

  def plan(%AST.TableExpr{expr: %AST.Identifier{} = identifier} = from, ctes, context) when is_list(ctes) do
    cte =
      Enum.find(ctes, fn cte ->
        cte.identifier.value == identifier.value
      end)

    Planner.plan(cte.expr, ctes, context)
    |> Enum.map(fn record ->
      %Exd.Record{value: %{from.name.value => record}}
    end)
    |> Flow.from_enumerable(stages: 1)
  end

  def plan(%AST.TableExpr{
    name: name,
    expr: %AST.CallExpr{
      identifier: %AST.Identifier{value: "unnest"},
      params: params
    },
  }, _, context)
  do
    records =
      for literal <- params do
        value = Evaluator.eval(%Exd.Record{}, literal)
        %Exd.Record{value: %{name.value => value}}
      end
    Flow.from_enumerable(records, stages: 1)
  end

  def plan(%AST.TableExpr{
    name: name,
    expr: %AST.CallExpr{
      identifier: %AST.Identifier{value: caller},
      params: params
    },
  },
  _,
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
