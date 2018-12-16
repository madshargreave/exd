defmodule Exd.Codegen.Planner.From do
  @moduledoc false
  alias Exd.AST

  @functions ~w(range fetch)

  def plan(%AST.TableExpr{expr: [%AST.NumberLiteral{} | _rest]} = from) do
    name = from.name.value
    from.expr
    |> Enum.map(&%Exd.Record{value: %{name => &1.value}})
    |> Flow.from_enumerable(stages: 1, max_demand: 10)
  end

  def plan(%AST.TableExpr{
    expr: %AST.CallExpr{
      identifier: %AST.Identifier{value: caller},
      arguments: [
        %AST.NumberLiteral{value: start},
        %AST.NumberLiteral{value: stop}
      ]
    },
  } = from)
    when caller in @functions
  do
    (start..stop)
    |> Enum.to_list
    |> Enum.map(&to_record(from.name, &1))
    |> Flow.from_enumerable(stages: 1, max_demand: 10)
  end

  defp to_record(nil, value),
    do: %Exd.Record{value: value}
  defp to_record(%AST.Identifier{value: name}, value),
    do: %Exd.Record{value: %{name => value}}

end
