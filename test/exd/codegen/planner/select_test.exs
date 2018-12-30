defmodule Exd.Codegen.Planner.SelectTest do
  use ExUnit.Case, async: false

  alias Exd.AST
  alias Exd.Codegen.Planner.Select

  describe "select/2" do
    test "it works with literal expressions" do
      context = %Exd.Context{}
      flow =
        [
          %Exd.Record{value: %{"first_name" => "mads"}},
          %Exd.Record{value: %{"first_name" => "jack"}},
          %Exd.Record{value: %{"first_name" => "john"}}
        ]
        |> Flow.from_enumerable

      program =
        %AST.SelectExpr{
          columns: [
            %AST.ColumnExpr{
              name: %AST.Identifier{
                value: "name"
              },
              expr: %AST.BindingExpr{
                family: nil,
                identifier: %AST.Identifier{
                  value: "first_name"
                }
              }
            },
            %AST.ColumnExpr{
              name: %AST.Identifier{
                value: "age"
              },
              expr: %AST.NumberLiteral{
                value: 25
              }
            }
          ]
        }

      assert [
        %{"name" => "mads", "age" => 25},
        %{"name" => "jack", "age" => 25},
        %{"name" => "john", "age" => 25}
      ] ==
        flow
        |> Select.plan(program, context)
        |> Enum.to_list
    end

    test "it works with unnesting" do
      context = %Exd.Context{}
      flow =
        [
          %Exd.Record{value: %{"numbers" => [1, 2, 3]}},
          %Exd.Record{value: %{"numbers" => [4, 5]}}
        ]
        |> Flow.from_enumerable

      program =
        %AST.SelectExpr{
          columns: [
            %AST.ColumnExpr{
              name: %AST.Identifier{
                value: "age"
              },
              expr: %AST.NumberLiteral{
                value: 25
              }
            },
            %AST.ColumnExpr{
              name: %AST.Identifier{
                value: "number"
              },
              expr: %AST.CallExpr{
                identifier: %AST.Identifier{
                  value: "unnest"
                },
                params: [
                  %AST.BindingExpr{
                    identifier: %AST.Identifier{
                      value: "numbers"
                    }
                  }
                ]
              },
            }
          ]
        }

      assert [
        %{"number" => 1, "age" => 25},
        %{"number" => 2, "age" => 25},
        %{"number" => 3, "age" => 25},
        %{"number" => 4, "age" => 25},
        %{"number" => 5, "age" => 25},
      ] ==
        flow
        |> Select.plan(program, context)
        |> Enum.to_list
    end
  end

end
