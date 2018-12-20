defmodule Exd.Codegen.PlannerTest do
  use ExUnit.Case

  alias Exd.AST
  alias Exd.Codegen.Planner

  describe "plan/1" do
    test "asda" do
      program =
        %AST.Program{
          query: %AST.Query{
            from: %AST.FromExpr{
              name: %AST.Identifier{value: "numbers"},
              expr: [
                %AST.NumberLiteral{value: 1},
                %AST.NumberLiteral{value: 2},
                %AST.NumberLiteral{value: 3}
              ]
            },
            select: %AST.SelectExpr{
              columns: [
                %AST.ColumnExpr{
                  name: %AST.Identifier{value: "number"},
                  expr: %AST.BindingExpr{
                    family: "numbers",
                    identifier: nil
                  }
                }
              ]
            }
          }
        }

      assert [
        %{"number" => 1},
        %{"number" => 2},
        %{"number" => 3}
      ] ==
        program
        |> Planner.plan
        |> Enum.to_list
    end
  end

end
