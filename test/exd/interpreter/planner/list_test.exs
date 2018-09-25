# defmodule Exd.Planner.ListTest do
#   use Exd.PluginCase,
#     plugin: Exd.Plugin.List

#   alias Exd.Query
#   alias Exd.Repo
#   alias Exd.Planner

#   describe "unnest/2" do
#     test "it works dynamically" do
#       page =
#         Query.new
#         |> Query.from(
#           "page",
#           {:http_crawl, "https://coinmarketcap.com"}
#         )
#         |> Query.select(%{
#           rows: {:html_parse_list, "page.document", "'table#currencies tr'"},
#           total_marketcap: {:html_parse_integer, "page.document", "'.global-marketcap'"}
#         })

#       coins =
#         Query.new
#         |> Query.from("page", page)
#         |> Query.select(%{
#           name: {:html_parse_text, "page.rows", "'.currency-name-name'"},
#           symbol: {:html_parse_text, "page.rows", "'.currency-symbol-name'"},
#           marketcap: {:html_parse_currency, "page.rows", "'.currency-marketcap-name'"},
#           price: {:html_parse_currency, "page.rows", "'.currency-price-name'"},
#           total_marketcap: "page.total_marketcap"
#         })
#     end
#   end

# end
