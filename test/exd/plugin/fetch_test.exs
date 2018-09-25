defmodule Exd.Plugin.FetchTest do
  use Exd.QueryCase
  alias Exd.Repo

  # def get(symbol) do
  #   opts = [{:symbol, key: symbol, ttl: 5000}]

  #   Repo.first(
  #     from b in fetch(interpolate("https://coinmarketcap.com/currencies/?", ^symbol)),
  #     select: %{
  #       name: html_parse_text(b.body, ".coin-name"),
  #       symbol: html_parse_text(b.body, ".coin-symbol"),
  #       price: html_parse_text(b.body, ".coin-price"),
  #       marketcap: html_parse_text(b.body, ".coin-marketcap"),
  #       volume: html_parse_text(b.body, ".coin-volume")
  #     },
  #     opts
  #   )
  # end

  describe "fetch/1" do
    test "it fetches pages" do
      assert %{
        status: 200,
        body: _body
      } =
        Repo.first(
          from b in fetch("https://coinmarketcap.com"),
          where: b.status == 200,
          select: %{
            status: b.status,
            body: b.body
          }
        )
    end

    # test "it works with piping" do
    #   overview =
    #     from r in fetch("https://coinmarketcap.com"),
    #     where: r.status == 200,
    #     select: %{
    #       row: unnest(html_parse_list(r.body, "table#currencies > tbody > tr"))
    #     }

    #   coins =
    #     from o in overview,
    #     where: o.marketcap > 100_000_000,
    #     select: %{
    #       name: html_parse_text(o.row, ".container-name"),
    #       href: html_parse_attr(o.row, "href", ".container-name"),
    #       symbol: html_parse_text(o.row, ".container-symbol"),
    #       price: html_parse_float(o.row, ".container-price"),
    #       marketcap: html_parse_float(o.row, ".container-marketcap"),
    #       volume: html_parse_float(o.row, ".container-volume")
    #     }

    #   detail =
    #     from r in fetch(
    #       interpolate("https://coinmarketcap.com/currencies/?", args.symbol),
    #       retries: 3,
    #       timeout: 5000
    #     ),
    #     where: r.status == 200,
    #     select: %{
    #       symbol: html_parse_text(l.body, ".container-symbol"),
    #       explorer: html_parse_attr(l.body, "href", ".container-explorer"),
    #       website: html_parse_attr(l.body, "href", ".container-website"),
    #       forum: html_parse_attr(l.body, "href", ".container-forum"),
    #       twitter_followers: html_parse_attr(l.body, "href", ".container-twitter-followers"),
    #       reddit_subs: html_parse_attr(l.body, "href", ".container-reddit-subs")
    #     }

    #   results =
    #     Repo.all(
    #       from c in coins,
    #       join: d in details, on: d.symbol = c.symbol,
    #       where: d.twitter_followers > 1000,
    #       select: [c, d]
    #     )
    # end
  end

end
