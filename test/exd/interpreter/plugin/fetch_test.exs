defmodule Exd.Plugin.FetchTest do
  use Exd.QueryCase
  alias Exd.Repo

  describe "fetch/1" do
    test "it works as a source" do
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

    # test "it works as a join" do
    #   assert [
    #     %{status: 200},
    #     %{status: 200},
    #     %{status: 200}
    #   ] =
    #     Repo.first(
    #       from b in ["bitcoin", "ethereum", "ripple"],
    #       join_lateral: r in subquery(
    #         from r in fetch(
    #           interpolate("https://coinmarketcap.com/currencies/?", b)
    #         )
    #       ),
    #       select: %{
    #         status: b.status
    #       }
    #     )
    # end
  end
end
