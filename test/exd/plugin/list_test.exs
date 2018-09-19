defmodule Exd.Plugin.ListTest do
  use Exd.PluginCase,
    plugin: Exd.Plugin.List

  alias Exd.Query
  alias Exd.Repo

  describe "unnest/2" do
    test "it works when selecting" do
      assert [
        %{"id" => 1, "value" => 1},
        %{"id" => 1, "value" => 2},
        %{"id" => 1, "value" => 3},
        %{"id" => 2, "value" => 4},
        %{"id" => 2, "value" => 5},
        %{"id" => 2, "value" => 6}
      ] ==
        Query.new
        |> Query.from(
          "numbers",
          [
            %{"id" => 1, "values" => [1, 2, 3]},
            %{"id" => 2, "values" => [4, 5, 6]}
          ]
        )
        |> Query.select(%{
          "id" => "numbers.id",
          "value" => {:unnest, "numbers.values"}
        })
        |> Query.to_list
    end

    test "it works when selecting from subquery" do
      numbers =
        Query.new
        |> Query.from(
          "numbers",
          [
            %{"id" => 1, "values" => [1, 2, 3]},
            %{"id" => 2, "values" => [4, 5, 6]}
          ]
        )
        |> Query.select(%{
          "id" => "numbers.id",
          "value" => {:unnest, "numbers.values"}
        })

      assert [
        %{"id" => 1, "value" => 1},
        %{"id" => 1, "value" => 2},
        %{"id" => 1, "value" => 3},
        %{"id" => 2, "value" => 4},
        %{"id" => 2, "value" => 5},
        %{"id" => 2, "value" => 6}
      ] ==
        Query.new
        |> Query.from("numbers", numbers)
        |> Query.select(%{
          "id" => "numbers.id",
          "value" => "numbers.value"
        })
        |> Query.to_list
    end
  end

end
