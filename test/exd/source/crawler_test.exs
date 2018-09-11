# defmodule Exd.Source.CrawlerTest do
#   use ExUnit.Case

#   alias Exd.Query
#   alias Exd.Repo
#   alias Exd.Source.Crawler, as: CrawlerAdapter

#   describe "from/1" do
#     test "it returns preconfigured value" do
#       assert [
#         {"bitcoin", "btc", _},
#         {"ethereum", "eth", _} | _rest
#       ] =
#         Query.new
#         |> Query.from(
#           "coins",
#           {
#             CrawlerAdapter,
#               url: "https://coinmarketcap.com",
#               container: "table#currencies > tbody > tr",
#               mapping: [
#                 %{
#                   "key" => "name",
#                   "transforms" => [
#                     %{"access" => "a.currency-name-container"},
#                     %{"lowercase" => true}
#                   ]
#                 },
#                 %{
#                   "key" => "symbol",
#                   "transforms" => [
#                     %{"access" => ".circulating-supply > span > span:last-child"},
#                     %{"lowercase" => true}
#                   ]
#                 },
#                 %{
#                   "key" => "marketcap",
#                   "transforms" => [
#                     %{"access" => ".market-cap"},
#                     %{"trim" => true},
#                     %{"regex" => "([0-9\,]+)"},
#                     %{"replace" => [",", ""]},
#                     %{"cast" => "integer"}
#                   ]
#                 },
#               ]
#           }
#         )
#         |> Query.select({"coins.name", "coins.symbol", "coins.marketcap"})
#         |> Repo.stream
#         |> Enum.sort_by(&elem(&1, 2), &>=/2)
#     end
#   end
# end
