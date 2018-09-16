# # defmodule Exd.Source.CrawlerTest do
# #   use ExUnit.Case

# #   alias Exd.Query
# #   alias Exd.Repo
# #   alias Exd.Source.Crawler, as: CrawlerAdapter

# #   describe "from/1" do
# #     test "it returns preconfigured value" do
# #       assert [
# #         {"bitcoin", "btc", _},
# #         {"ethereum", "eth", _} | _rest
# #       ] =
# #         Query.new
# #         |> Query.from(
# #           "coins",
# #           {
# #             CrawlerAdapter,
# #               url: "https://coinmarketcap.com",
# #               container: "table#currencies > tbody > tr",
# #               mapping: [
# #                 %{
# #                   "key" => "name",
# #                   "transforms" => [
# #                     %{"access" => "a.currency-name-container"},
# #                     %{"lowercase" => true}
# #                   ]
# #                 },
# #                 %{
# #                   "key" => "symbol",
# #                   "transforms" => [
# #                     %{"access" => "a.symbol-container"},
# #                     %{"lowercase" => true}
# #                   ]
# #                 },
# #                 %{
# #                   "key" => "details_link",
# #                   "transforms" => [
# #                     %{"access" => ".currency-name-container"},
# #                     %{"attr" => "href"}
# #                   ]
# #                 }
# #               ]
# #           }
# #         )
# #         |> Query.join(
# #           "details",
# #           {
# #             CrawlerAdapter,
#               # url: "https://coinmarketcap.com/currencies/{{symbol}}",
#               # container: "'document'"
#               # concurrency: 2,
#               # retries: 3,
#               # timeout: 5000
# #           },
# #           %{
# #             symbol: "coins.symbol"
# #           }
# #         )
# #         |> Query.select({"coins.name", "coins.symbol", "coins.marketcap"})
# #         |> Repo.stream
# #         |> Enum.sort_by(&elem(&1, 2), &>=/2)
# #     end
# #   end
# # end


# coinmarket = %Exd.Query{
#   from: {
#     CrawlerAdapter,
#       key: "symbol",
#       url: "https://coinmarketcap.com",
#       container: "table#currencies > tbody > tr",
#       timeout: 5000
#   },
#   select: %{
#     name: {
#       :lowercase, {:access, "a.currency-name-container"}
#     },
#     symbol: {
#       :lowercase, {:access, ".circulating-supply > span > span:last-child"}
#     },
#     marketcap: {
#       :cast, {
#         :replace, {
#           :regex, {
#             {:access, ".market-cap"},
#             "$([0-9\,]+)"
#           },
#           ",",
#           ""
#         },
#         :integer
#       }
#     }
#   }
# }

# stats = %Exd.Query{
#   from: {
#     RequestAdapter,
#       method: :get,
#       url: {:replace, "https://coinstats.com/api/v1/{{symbol}}/stats", symbol: "context.symbol"},
#       headers: [
#         authorization: {:replace, "Bearer {{token}}", "context.token"}
#       ],
#       concurrency: 5,
#       retries: 3,
#       timeout: 5000
#   },
#   select: %{
#     http_code: {
#       :access, "status_code"
#     },
#     data: %{
#       twitter_followers: {
#         :access, "data.twitter.followers"
#       },
#       reddit_subscribers: {
#         :access, "data.reddit.subscribers"
#       }
#     }
#   }
# }

# Repo.stream(query, symbol: symbol)

# coin_store = {
#   StoreSource,
#     key: "symbol",
#     adapter: {
#       MemoryStore,
#         name: :my_store
#     }
# }

# new_coins =
#   Exd.Query.new
#   |> Exd.Query.from("coins", coinmarket)
#   |> Exd.Query.join("existing", coin_store, key: "coins.symbol")
#   |> Exd.Query.select("coins")

# coins =
#   Exd.Query.new
#   |> Exd.Query.from("coins", new_coins)
#   |> Exd.Query.join("stats", stats, symbol: "coins.symbol", token: "API_TOKEN")
#   |> Exd.Query.select({
#     symbol: "coins.symbol",
#     marketcap: "coins.marketcap",
#     price: "coins.price",
#     twitter_followers: "stats.data.twitter_followers",
#     reddit_subscribers: "stats.data.reddit_subscribers",
#     stats_success: {:gte, "stats.http_code", 300},
#   })

# errors =
#   Exd.Query.new
#   |> Exd.Query.from("coins", coins)
#   |> Exd.Query.where("coins.stats_success", :=, false)
#   |> Exd.Query.into({
#     RedisSink,
#       host: "localhost",
#       topic: "failed",
#       payload: %{
#         channel_id: "coins.channel_id"
#       }
#   })
#   |> Exd.Query.select(nil)

# success =
#   Exd.Query.new
#   |> Exd.Query.from("coins", coins)
#   |> Exd.Query.where("coins.stats_success", :=, true)
#   |> Exd.Query.into(coin_store)
#   |> Exd.Query.into({
#     EmailSink,
#       to: "mads.hargreave@gmail.com",
#       from: "test app",
#       subject: "[Coin alert]: {{coins.symbol}} was added to Coinmarketcap",
#       content: "{{coins.symbol}} was added to Coinmarketcap"
#   })
#   |> Exd.Query.select(nil)


# result =
#   Exd.Query.new
#   |> Exd.Query.from("all", [errors, success])
#   |> Repo.run
