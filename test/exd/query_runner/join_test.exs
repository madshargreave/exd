defmodule Exd.Runner.JoinTest do
  use ExUnit.Case

  alias Exd.{Query, Record}
  alias Exd.Runner.Planner
  alias Exd.Record

  describe "from/2" do
    test "it returns preconfigured value" do
      assert [
        %Record{value: %{
          "coins" => %{"name" => "bitcoin"},
          "length" => 7
        }},
        %Record{value: %{
          "coins" => %{"name" => "ethereum"},
          "length" => 8
        }},
        %Record{value: %{
          "coins" => %{"name" => "ripple"},
          "length" => 6
        }}
      ] =
        Query.new
        |> Query.from(
          "coins",
          [
            %{"name" => "bitcoin"},
            %{"name" => "ethereum"},
            %{"name" => "ripple"}
          ]
        )
        |> Query.join(
          "length",
          fn records ->
            for record <- records, do: String.length(record.value["coins"]["name"])
          end
        )
        |> Planner.plan
        |> Enum.sort_by& get_in(&1.value, ~w(coins name))
    end

  end
end
