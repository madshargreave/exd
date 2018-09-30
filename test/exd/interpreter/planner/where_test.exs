defmodule Exd.Interpreter.WhereTest do
  use Exd.QueryCase
  alias Exd.{Repo, Query}
  doctest Exd.Interpreter.Where

  describe "filtering" do
    test "it filters results" do
      assert [
        "jack",
        "john"
      ] ==
        Repo.all(
          %Query{
            from: {
              :c,
              [
                %{name: "mads", age: 22},
                %{name: "jack", age: 26},
                %{name: "john", age: 30}
              ]
            },
            where: [
              {{:binding, [:c, :age]}, :>, 25}
            ],
            select: {:binding, [:c, :name]}
          }
        )
    end
  end
end
