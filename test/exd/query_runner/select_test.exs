defmodule Exd.Runner.SelectTest do
  use ExUnit.Case

  alias Exd.{Query, Record}
  alias Exd.Runner.Planner
  alias Exd.Record

  describe "select/2" do
    test "it works with referenced values" do
      assert [
        %{"name" => "bitcoin", "length" => 7}
      ] =
        base_query()
        |> Query.select(%{
          "name" => "coins.name",
          "length" => "length"
        })
        |> Planner.plan
        |> Enum.sort_by & &1["name"]
    end

    test "it works with literal strings" do
      assert [
        %{"name" => "bitcoin", "status" => "cool"}
      ] =
        base_query()
        |> Query.select(%{
          "name" => "coins.name",
          "status" => "'cool'"
        })
        |> Planner.plan
        |> Enum.sort_by & &1["name"]
    end

    test "it works with literal integers" do
      assert [
        %{"name" => "bitcoin", "status" => 1}
      ] =
        base_query()
        |> Query.select(%{
          "name" => "coins.name",
          "status" => 1
        })
        |> Planner.plan
        |> Enum.sort_by & &1["name"]
    end
  end

  defp base_query do
    Query.new
    |> Query.from(
      "coins",
      [
        %{"name" => "bitcoin"}
      ]
    )
    |> Query.join(
      "length",
      fn records ->
        for record <- records, do: String.length(record.value["coins"]["name"])
      end
    )
  end

end
