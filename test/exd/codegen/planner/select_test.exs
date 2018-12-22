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

    test "it works with select all expression" do
      context = %Exd.Context{}
      flow =
        [
          %Exd.Record{value: %{"first_name" => "mads", "last_name" => "hargreave"}},
          %Exd.Record{value: %{"first_name" => "jack", "last_name" => "sparrow"}},
          %Exd.Record{value: %{"first_name" => "john", "last_name" => "doe"}}
        ]
        |> Flow.from_enumerable

      program =
        %AST.SelectExpr{
          columns: [
            # %AST.ColumnExpr{
            #   expr: %AST.ColumnRef{
            #     all: true,
            #   },
            # },
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

      # assert [
      #   %{"first_name" => "mads", "last_name" => "hargreave", "age" => 25},
      #   %{"first_name" => "jack", "last_name" => "sparrow", "age" => 25},
      #   %{"first_name" => "john", "last_name" => "doe", "age" => 25}
      # ] ==
      #   flow
      #   |> Select.plan(program, context)
      #   |> Enum.to_list
    end
  end

end
