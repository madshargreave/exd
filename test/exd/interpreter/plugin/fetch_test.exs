defmodule Exd.Plugin.FetchTest do
  use Exd.QueryCase
  alias Exd.Repo

  describe "fetch/1" do
    test "it fetches pages" do
      assert %{
        status: 200,
        body: _body
      } =
        Repo.first(
          from b in fetch("https://coinmarketcap.com"),
          select: %{
            status: b.status,
            body: b.body
          }
        )
    end
  end
end
