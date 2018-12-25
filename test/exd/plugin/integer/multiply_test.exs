defmodule Exd.Plugin.Integer.MultiplyTest do
  use ExUnit.Case

  alias Exd.AST
  alias Exd.Codegen.Planner

  describe "plan/1" do
    test "asda" do
      program =
        %AST.Program{
          query: %AST.Query{
            from: %AST.TableExpr{
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
                  name: %AST.Identifier{value: "double"},
                  expr: %AST.CallExpr{
                    identifier: %AST.Identifier{value: "multiply"},
                    params: [
                      %AST.BindingExpr{
                        family: "numbers",
                        identifier: nil
                      },
                      %AST.NumberLiteral{value: 2}
                    ]
                  }
                }
              ]
            }
          }
        }

      assert [
        %{"double" => 2},
        %{"double" => 4},
        %{"double" => 6}
      ] ==
        program
        |> Planner.plan
        |> Enum.to_list
    end
  end

end
