defmodule Exd.Interpreter.FromTest do
  use Exd.QueryCase
  doctest Exd.Interpreter.From
  alias Exd.{Repo, Query, Record}

  describe "from/4" do
    test "it works with list literals" do
      assert [
        %{"name" => "bitcoin"},
        %{"name" => "ethereum"},
        %{"name" => "ripple"}
      ] =
        Repo.all(
          %Query{
            from: {
              "c",
              [
                %{"name" => "bitcoin"},
                %{"name" => "ethereum"},
                %{"name" => "ripple"}
              ]
            },
            select: {:binding, ["c"]}
          }
        )
    end

    test "it works with subqueries" do
      subquery =
        %Query{
          from: {
            "inner",
            [
              %{"name" => "bitcoin"},
              %{"name" => "ethereum"},
              %{"name" => "ripple"}
            ]
          },
          select: {:binding, ["inner"]}
        }

      assert [
        "bitcoin",
        "ethereum",
        "ripple"
      ] =
        Repo.all(
          %Query{
            from: {
              "outer",
              {
                :subquery,
                [subquery]
              }
            },
            select: {:binding, ["outer", "name"]}
          }
        )
    end
  end
end
