defmodule Exd.Codegen.PlannerTest do
  use ExUnit.Case

  alias Exd.AST
  alias Exd.Codegen.Planner

  describe "plan/1" do
    test "asda" do
      meta = %{some_data: 123}
      program =
        %AST.Program{
          query: %AST.Query{
            from: %AST.TableExpr{
              name: %AST.Identifier{value: "numbers"},
              expr: %AST.CallExpr{
                identifier: %AST.Identifier{
                  value: "unnest"
                },
                params: [
                  %AST.NumberLiteral{value: 1},
                  %AST.NumberLiteral{value: 2},
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
        |> Planner.plan(meta)
        |> Enum.to_list
    end
  end

end
