# defmodule Exd.Runner.JoinTest do
#   use ExUnit.Case

#   alias Exd.{Repo, Query}
#   alias Exd.Runner.Join
#   alias Exd.Source.List, as: ListSource

#   describe "joining" do
#     test "it works with multiple sinks" do
#       coins = {
#         ListSource,
#           value: [
#             %{"name" => "bitcoin", "symbol" => "btc"},
#             %{"name" => "ethereum", "symbol" => "eth"},
#             %{"name" => "ripple", "symbol" => "xrp"}
#           ]
#       }

#       stats = {
#         ListSource,
#           key: "symbol",
#           value: [
#             %{"symbol" => "btc", "followers" => 150},
#             %{"symbol" => "eth", "followers" => 100}
#           ]
#       }

#       assert [
#         %{"name" => "bitcoin", "symbol" => "btc", "followers" => 150},
#         %{"name" => "ethereum", "symbol" => "eth", "followers" => 100}
#       ] ==
#         Query.new
#         |> Query.from("coins", coins)
#         |> Query.join("stats", stats, key: "coins.symbol")
#         |> Repo.stream
#         |> Enum.sort_by & &1["name"], &>=/2
#     end
#   end
# end
