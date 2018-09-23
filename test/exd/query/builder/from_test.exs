defmodule Exd.Query.Builder.FromTest do
  import Exd.Query.API
  use ExUnit.Case

  alias Exd.Query

  describe "rewriting" do
    test "it works for literals" do
      assert %Query{
        from: {"numbers", [1, 2, 3], []}
      } ==
        from numbers in [1, 2, 3]
    end

    test "it works for list of maps" do
      assert %Query{
        from: {"p", [%{"name" => "mads"}], []},
        select: "p.name"
      } ==
        from p in [%{"name" => "mads"}],
        select: p.name
    end

    test "it works for expressions" do
      assert %Query{
        from: {"response", {:fetch, "'https://coinmarketcap.com'"}, []}
      } ==
        from response in {:fetch, "https://coinmarketcap.com"}
    end
  end

end
