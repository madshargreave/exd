defmodule Exd.Transport.RequestTest do
  use ExUnit.Case

  alias Exd.Query
  alias Exd.Repo
  alias Exd.Source.List, as: ListSource
  alias Exd.Transport.Test, as: TestTransport
  alias Exd.Transport.Request, as: RequestTransport

  describe "into/3" do
    test "it works with multiple sinks" do
      items =
        Query.new
        |> Query.from(
          "coins",
          {
            RequestTransport,
              url: "https://coinmarketcap.com",
              method: :get,
              timeout: 5000,
              retries: 3
          }
        )
        |> Query.select(%{
          total: {:access, ".total-market.cap"},
          items: {:access, "table#currencies tr"}
        })

      parsed =
        Query.new
        |> Query.from("raw", items)
        |> Query.select(%{
          name: {:attr, {:access, "raw.items", "a.currency-name-container"}, :href},
          symbol: {:access, "raw.items", "a.symbol-container"}
        })
    end
  end
end

example = "
  CREATE SOURCE overview AS (
    WITH response AS (
      SELECT *
      FROM http('get', 'https://coinmarketcap.com')
    ), items AS (
      SELECT html_parse_list(response.data, 'table#currencies tr')
      FROM response
    )
    SELECT
      html_parse_text(items, 'a.name-container') AS name,
      html_parse_text(items, 'a.symbol-container') AS symbol,
      html_parse_currency(items, 'a.price') AS price,
      html_parse_currency(items, 'a.marketcap') AS marketcap
    FROM UNNEST(items)
  )

  CREATE SOURCE detail (symbol string) AS (
    WITH response AS (
      SELECT *
      FROM http(
        'get',
        REPLACE('https://coinmarketcap.com/currencies/?', symbol)
      )
    )
    SELECT
      html_parse_text(response.data, 'twitter_followers') AS twitter_followers,
      html_parse_text(response.data, 'reddit_subs') AS reddit_subs
    FROM response

  INSERT INTO coins (name, symbol, price, marketcap, twitter_followers, reddit_subs)
  SELECT
    overview.name,
    overview.symbol,
    overview.price,
    overview.marketcap,
    detail.twitter_followers,
    detail.reddit_subs
  FROM overview
  JOIN detail ON detail.symbol = overview.symbol
  WHERE marketcap > 100000000
"
