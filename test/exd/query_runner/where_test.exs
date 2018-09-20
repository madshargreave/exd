# defmodule Exd.Runner.WhereTest do
#   use ExUnit.Case

#   alias Exd.{Query, Record}
#   alias Exd.Runner.Planner
#   alias Exd.Record

#   describe "where/3" do
#     test "it works when left value is referenced" do
#       assert [
#         %Record{value: %{
#           "coins" => %{"name" => "bitcoin", "price" => 1000}
#         }},
#         %Record{value: %{
#           "coins" => %{"name" => "ethereum", "price" => 750}
#         }}
#       ] =
#         base_query_fixture()
#         |> Query.where("coins.price", :>, 600)
#         |> Planner.plan
#         |> Enum.sort_by& get_in(&1.value, ~w(coins name))
#     end

#     test "it works when right value is referenced" do
#       assert [
#         %Record{value: %{
#           "coins" => %{"name" => "bitcoin", "price" => 1000}
#         }},
#         %Record{value: %{
#           "coins" => %{"name" => "ethereum", "price" => 750}
#         }}
#       ] =
#         base_query_fixture()
#         |> Query.where(600, :<, "coins.price")
#         |> Planner.plan
#         |> Enum.sort_by& get_in(&1.value, ~w(coins name))
#     end

#     test "it works with expressions" do
#       assert [
#         %Record{value: %{
#           "coins" => %{"name" => "bitcoin", "price" => 1000}
#         }}
#       ] =
#         base_query_fixture()
#         |> Query.where({:subtract, "coins.price", 300}, :>, 600)
#         |> Planner.plan
#         |> Enum.sort_by& get_in(&1.value, ~w(coins name))
#     end
#   end

#   defp base_query_fixture do
#     Query.new
#     |> Query.from(
#       "coins",
#       [
#         %{"name" => "bitcoin", "price" => 1000},
#         %{"name" => "ethereum", "price" => 750},
#         %{"name" => "ripple", "price" => 500}
#       ]
#     )
#   end

# end
