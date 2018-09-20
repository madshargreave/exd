defmodule Exd.Plugin.FetchTest do
  use Exd.PluginCase, plugin: Exd.Plugin.Fetch
  alias Exd.Query

  describe "fetch/3" do
    test "it fetches pages" do
      assert [
        %{
          "status" => 200,
          "body" => _body
        }
      ] =
        Query.new
        |> Query.from("body", {:fetch, "'https://coinmarketcap.com'"})
        |> Query.select("body")
        |> Query.to_list
    end
  end

end
