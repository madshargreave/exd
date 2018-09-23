# defmodule Exd.Runner.SelectTest do
#   use ExUnit.Case

#   alias Exd.{Query, Record}
#   alias Exd.Runner.Planner
#   alias Exd.Record

#   describe "select/2" do
#     test "it works with referenced values" do
#       assert [
#         %{"name" => "bitcoin"}
#       ] =
#         base_query()
#         |> Query.select(%{
#           "name" => "coins.name"
#         })
#         |> Planner.plan
#         |> Enum.sort_by & &1["name"]
#     end

#     test "it works when selecting namespace" do
#       assert [
#         %{"name" => "bitcoin", "price" => 1000}
#       ] ==
#         base_query()
#         |> Query.select("coins")
#         |> Planner.plan
#         |> Enum.sort_by & &1["name"]
#     end

#     test "it works with literal strings" do
#       assert [
#         %{"name" => "bitcoin", "quoted" => "coins.name"}
#       ] =
#         base_query()
#         |> Query.select(%{
#           "name" => "coins.name",
#           "quoted" => "'coins.name'"
#         })
#         |> Planner.plan
#         |> Enum.sort_by & &1["name"]
#     end

#     test "it works with literal integers" do
#       assert [
#         %{"name" => "bitcoin", "status" => 1}
#       ] =
#         base_query()
#         |> Query.select(%{
#           "name" => "coins.name",
#           "status" => 1
#         })
#         |> Planner.plan
#         |> Enum.sort_by & &1["name"]
#     end

#     test "it works with tuples" do
#       assert [
#         {"bitcoin", 1}
#       ] =
#         base_query()
#         |> Query.select({"coins.name", 1})
#         |> Planner.plan
#         |> Enum.sort_by & elem(&1, 0)
#     end

#     test "it works with lists of strings" do
#       assert [
#         %{"name" => "bitcoin", "price" => 1000}
#       ] =
#         base_query()
#         |> Query.select(["coins"])
#         |> Planner.plan
#         |> Enum.sort_by & &1["name"]
#     end
#   end

#   defp base_query do
#     Query.new
#     |> Query.from(
#       "coins",
#       [
#         %{"name" => "bitcoin", "price" => 1000}
#       ]
#     )
#   end

# end
