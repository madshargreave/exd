# defmodule Exd.QueryRunnerTest do
#   use ExUnit.Case

#   alias Exd.QueryRunner
#   alias Exd.Query

#   describe "stream/1" do
#     test "it works with simple selection" do
#       assert [
#         {"bitcoin", "btc"},
#         {"ethereum", "eth"},
#         {"ripple", "xrp"}
#       ] ==
#         Query.new
#         |> Query.from(
#           "coins",
#           [
#             %{"name" => "bitcoin", "symbol" => "btc"},
#             %{"name" => "ethereum", "symbol" => "eth"},
#             %{"name" => "ripple", "symbol" => "xrp"}
#           ]
#         )
#         |> Query.select({"coins.name", "coins.symbol"})
#         |> QueryRunner.stream
#         |> Enum.to_list
#     end

#     test "it works with subquery" do
#       assert [
#         %{
#           "name" => "bitcoin",
#           "symbol" => "btc",
#           "marketcap" => 100_000_000
#         },
#         %{
#           "name" => "ethereum",
#           "symbol" => "eth",
#           "marketcap" => 25_000_000
#         }
#       ] ==
#         Query.new
#         |> Query.from(
#           "outer",
#           Query.new
#           |> Query.from(
#             "inner",
#             [
#               %{"name" => "bitcoin", "symbol" => "btc", "marketcap" => 100_000_000},
#               %{"name" => "ethereum", "symbol" => "eth", "marketcap" => 25_000_000},
#               %{"name" => "ripple", "symbol" => "xrp", "marketcap" => 10_000_000}
#             ]
#           )
#         )
#         |> Query.where("outer.marketcap", :>, 15_000_000)
#         |> Query.select(%{
#           "name" => "outer.name",
#           "symbol" => "outer.symbol",
#           "marketcap" => "outer.marketcap"
#         })
#         |> QueryRunner.stream
#         |> Enum.to_list
#     end

#     test "it works with multiple subqueries" do
#       sub1 =
#         Query.new
#         |> Query.from(
#           "inner",
#           [
#             %{"name" => "bitcoin", "symbol" => "btc", "marketcap" => 100_000_000},
#             %{"name" => "ethereum", "symbol" => "eth", "marketcap" => 25_000_000}
#           ]
#         )

#       sub2 =
#         Query.new
#         |> Query.from(
#           "inner",
#           [
#             %{"name" => "ripple", "symbol" => "xrp", "marketcap" => 10_000_000}
#           ]
#         )

#       assert [
#         %{
#           "name" => "bitcoin",
#           "symbol" => "btc",
#           "marketcap" => 100_000_000
#         },
#         %{
#           "name" => "ethereum",
#           "symbol" => "eth",
#           "marketcap" => 25_000_000
#         },
#         %{
#           "name" => "ripple",
#           "symbol" => "xrp",
#           "marketcap" => 10_000_000
#         }
#       ] ==
#         Query.new
#         |> Query.from("outer", [sub1, sub2])
#         |> Query.select(%{
#           "name" => "outer.name",
#           "symbol" => "outer.symbol",
#           "marketcap" => "outer.marketcap"
#         })
#         |> QueryRunner.stream
#         |> Enum.sort_by & &1["marketcap"], &>/2
#     end
#   end

# end
