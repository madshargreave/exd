defmodule Exd.Codegen.Planner.From do
  @moduledoc false
  alias Exd.AST

  @functions ~w(range fetch)

  def from(%AST.FromExpr{expr: [%AST.NumberLiteral{} | _rest]} = from) do
    name = from.name.value
    from.expr
    |> Enum.map(&%Exd.Record{value: %{name => &1.value}})
    |> Flow.from_enumerable()
  end

  def from(%AST.FromExpr{
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
    name = from.name.value
    (start..stop)
    |> Enum.to_list
    |> Enum.map(&%Exd.Record{value: %{name => &1}})
    |> Flow.from_enumerable()
  end

end
