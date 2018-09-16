defmodule Exd.Runner.FromTest do
  use ExUnit.Case

  alias Exd.{Query, Record}
  alias Exd.Runner.Planner
  alias Exd.Runner.From
  alias Exd.Source.List, as: ListSource

  describe "from/2" do
    test "it works with lists" do
      assert [
        %Record{key: "bitcoin", value: %{"coins" => %{"name" => "bitcoin"}}},
        %Record{key: "ethereum", value: %{"coins" => %{"name" => "ethereum"}}},
        %Record{key: "ripple", value: %{"coins" => %{"name" => "ripple"}}}
      ] =
        Query.new
        |> Query.from(
          "coins",
          [
            %{"name" => "bitcoin"},
            %{"name" => "ethereum"},
            %{"name" => "ripple"}
          ],
          max_demand: 1,
          key: fn event -> Kernel.get_in(event, ["coins", "name"]) end
        )
        |> Planner.plan()
        |> Enum.sort
    end

    test "it works with subqueries" do
      subquery =
        Query.new
        |> Query.from(
          "inner",
          [
            %{"name" => "bitcoin"},
            %{"name" => "ethereum"},
            %{"name" => "ripple"}
          ]
        )

      assert [
        %Record{key: "bitcoin", value: %{"coins" => %{"name" => "bitcoin"}}},
        %Record{key: "ethereum", value: %{"coins" => %{"name" => "ethereum"}}},
        %Record{key: "ripple", value: %{"coins" => %{"name" => "ripple"}}}
      ] =
        Query.new
        |> Query.from(
          "coins",
          subquery,
          max_demand: 1,
          key: fn event -> Kernel.get_in(event, ["coins", "name"]) end
        )
        |> Planner.plan()
        |> Enum.sort
    end
  end
end
