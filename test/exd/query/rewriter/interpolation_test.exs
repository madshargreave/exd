defmodule Exd.Query.Rewriter.InterpolationTest do
  use ExUnit.Case

  alias Exd.Query
  alias Exd.Query.Rewriter

  @people [
    %{"first_name" => "jack", "last_name" => "doe"},
    %{"first_name" => "john", "last_name" => "doe"}
  ]

  describe "rewriting" do
    test "it works" do
      assert %Query{
        select: %{
          "full_name" => {:interpolate, "'? ?'", ["people.first", "people.last"]}
        }
      } =
        Query.new
        |> Query.from("people", @people)
        |> Query.select(%{
          "full_name" => "'{{people.first}} {{people.last}}'"
        })
        |> Rewriter.rewrite
    end
  end

end
