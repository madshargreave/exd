# defmodule Exd.Plugin.FetchTest do
#   use Exd.QueryCase
#   alias Exd.Repo

#   describe "fetch/1" do
#     test "it fetches pages" do
#       assert %{
#         "status" => 200,
#         "body" => _body
#       } =
#         Repo.first(
#           from b in {:fetch, "https://coinmarketcap.com"},
#           where: b.status == 200,
#           select: b
#         )
#     end

#     test "it works with joins" do
#       details =
#         from r in {:fetch, interpolate("https://coinmarketcap.com/currencies/?", args.symbol)},
#         where: r.status == 200,
#         select: html_parse(r.body)

#       assert %{
#         "status" => 200,
#         "body" => _body
#       } =
#         Repo.first(
#           from symbol in ["bitcoin", "etheruem", "ripple"],
#           join: details, on: details.symbol = symbol,
#           where: details.status == 200,
#           select: %{
#             symbol: s,
#             name: html_parse_text(details.body, ".container-name"),
#             price: html_parse_text(details.body, ".container-price"),
#             marketcap: html_parse_text(details.body, ".container-marketcap"),
#             twitter_followers: html_parse_text(details.body, ".stats .twitter-followers"),
#             reddit_subs: html_parse_text(details.body, ".stats .reddit-subs")
#           }
#         )
#     end
#   end

# end
