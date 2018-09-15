# defmodule Exd.Transport.RequestTest do
#   use ExUnit.Case

#   alias Exd.Query
#   alias Exd.Repo
#   alias Exd.Source.List, as: ListSource
#   alias Exd.Transport.Test, as: TestTransport
#   alias Exd.Transport.Request, as: RequestTransport

#   describe "into/3" do
#     test "it works with multiple sinks" do
#       data =
#         Query.new
#         |> Query.from(
#           "coins",
#           {
#             ListSource,
#               value: [
#                 %{"_key" => 1, "name" => "bitcoin", "symbol" => "btc"},
#                 %{"_key" => 2, "name" => "ethereum", "symbol" => "eth"},
#                 %{"_key" => 3, "name" => "ripple", "symbol" => "xrp"}
#               ]
#           }
#         )
#         |> Query.join("data", coinmarketcap, symbol: "coins.symbol")
#         |> Query.where("data.marketcap", :>, 100_000_000)
#         |> Query.select(%{
#           name: "coins.name",
#           price: "data.price",
#           marketcap: "data.marketcap"
#         })

#       emails =
#         Query.new
#         |> Query.from("data", data)
#         |> Query.into(
#           "emails",
#           {
#             sendgrid_sink,
#               from: "data.from",
#               to: "data.to",
#               subject: "data.subject",
#               content: "data.content"
#           }
#         )
#         |> Query.returning(%{
#           id: "emails.id",
#           type: "'email'"
#         })

#       events =
#         Query.new
#         |> Query.from("results", [emails])
#         |> Repo.run
#     end
#   end

#   defp sendgrid_sink do
#     Query
#     |> Query.new
#     |> Query.from(
#       "context",
#       {
#         ContextSource,
#           args: [
#             to: {:string, required: true},
#             from: {:string, required: true},
#             subject: {:string, required: true},
#             content: {:string, required: true},
#           ]
#       }
#     )
#     |> Query.into(
#       "responses",
#       {
#         RequestTransport,
#           method: "'post'",
#           url: "https://api.sendgrid.com/v3/send",
#           params: %{
#             api_key: {:secret, "SENDGRID_API_TOKEN"}
#           },
#           data: %{
#             to: "context.to",
#             from: "context.from",
#             subject: "context.subject",
#             content: "context.content"
#           }
#       }
#     )
#     |> Query.returning(%{
#       status: "responses.status_code",
#       data: "responses.data"
#     })
#   end

#   defp coinmarketcap do
#     requests =
#       Query.new
#       |> Query.from(
#         "context",
#         {
#           ContextSource,
#             args: [
#               symbol: {:string, required: true}
#             ]
#         }
#       )
#       |> Query.select(%{
#         symbol: "coins.symbol",
#         url: {:replace, "https://coinmarketcap.com/markets/{{symbol}}.json", symbol: "context.symbol"},
#         method: :get,
#         timeout: 5000,
#         retries: 3
#       })

#     responses =
#       Query.new
#       |> Query.from("requests", requests)
#       |> Query.into(
#         "responses",
#         {
#           RequestTransport,
#             method: "requests.method",
#             url: "requests.url",
#             timeout: "requests.timeout",
#             retries: "requests.retries"
#         }
#       )
#       |> Query.select(%{
#         symbol: "requests.symbol",
#         data: "responses.data"
#       })

#     results =
#       Query.new
#       |> Query.from("responses", responses)
#       |> Query.select(%{
#         symbol: "responses.symbol",
#         price: "responses.data.price",
#         marketcap: "responses.data.marketcap"
#       })
#   end
# end
