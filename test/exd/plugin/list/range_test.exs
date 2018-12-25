defmodule Exd.Plugin.List.RangeTest do
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
              expr: %AST.CallExpr{
                identifier: %AST.Identifier{value: "range"},
                params: [
                  %AST.NumberLiteral{value: 1},
                  %AST.NumberLiteral{value: 3}
                ]
              }
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
        |> Planner.plan(hello: 1)
        |> Enum.to_list
    end
  end

end
