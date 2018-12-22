defmodule Exd.Codegen.Planner.FromTest do
  use ExUnit.Case

  alias Exd.AST
  alias Exd.Codegen.Planner.From

  describe "from/1" do
    test "it works with array literals" do
      context = %Exd.Context{}
      from =
        %AST.TableExpr{
          name: %AST.Identifier{value: "numbers"},
          expr: [
            %AST.NumberLiteral{value: 1},
            %AST.NumberLiteral{value: 2},
            %AST.NumberLiteral{value: 3}
          ]
        }

      assert [
        %Exd.Record{value: %{"numbers" => 1}},
        %Exd.Record{value: %{"numbers" => 2}},
        %Exd.Record{value: %{"numbers" => 3}}
      ] ==
        from
        |> From.plan(context)
        |> Enum.to_list
    end

    # test "it works with expressions" do
    #   from =
    #     %AST.TableExpr{
    #       name: %AST.Identifier{value: "numbers"},
    #       expr: %AST.CallExpr{
    #         identifier: %AST.Identifier{value: "range"},
    #         arguments: [
    #           %AST.NumberLiteral{value: 0},
    #           %AST.NumberLiteral{value: 2}
    #         ]
    #       }
    #     }

    #   assert [
    #     %Exd.Record{value: %{"numbers" => 0}},
    #     %Exd.Record{value: %{"numbers" => 1}},
    #     %Exd.Record{value: %{"numbers" => 2}}
    #   ] ==
    #     from
    #     |> From.plan
    #     |> Enum.to_list
    # end
  end

end
