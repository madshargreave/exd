defmodule Exd.Codegen.Planner.SelectTest do
  use ExUnit.Case

  alias Exd.AST
  alias Exd.Codegen.Planner.Select

  describe "select/2" do
    test "asda" do
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
              name: "name",
              expr: %AST.BindingExpr{
                family: nil,
                identifier: "first_name"
              }
            },
            %AST.ColumnExpr{
              name: "age",
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
        |> Select.select(program)
        |> Enum.to_list
    end
  end

end
