defmodule Exd.Query.Builder.SelectTest do
  use ExUnit.Case
  import Exd.Query.Builder
  doctest Exd.Query.Builder.Select

  describe "select/1" do
    test "it works when selecting binding" do
      # assert %Exd.Query{
      #   from: {"numbers", [1, 2, 3]},
      #   select: {:binding, ["numbers"]}
      # } ==
      #   from numbers in [1, 2, 3],
      #   select: numbers
    end

    # test "asdas" do
    #   assert %Exd.Query{
    #     from: {"d", {:fetch, ["https://dog.ceo/api/breeds/image/random"]}, []},
    #     select: {:binding, ["d", "body"]}
    #   } ==
    #     from d in fetch("https://dog.ceo/api/breeds/image/random"),
    #     select: d.body
    # end

    # test "it works when selecting map" do
    #   assert %Exd.Query{
    #     from: {"people", [%{"name" => "mads", "age" => 24}], []},
    #     select: %{
    #       name: {:binding, ["people", "name"]},
    #       age: {:binding, ["people", "age"]}
    #     }
    #   } ==
    #     from people in [%{"name" => "mads", "age" => 24}],
    #     select: %{
    #       name: people.name,
    #       age: people.age
    #     }
    # end

    # test "it works when selecting a function" do
    #   assert %Exd.Query{
    #     from: {"people", [%{"name" => "mads", "age" => 24}], []},
    #     select: %{
    #       name: {:interpolate, ["hello ?", {:binding, ["people", "name"]}]},
    #     }
    #   } ==
    #     from people in [%{"name" => "mads", "age" => 24}],
    #     select: %{
    #       name: interpolate("hello ?", people.name)
    #     }
    # end

    # test "it works with nested function expressions" do
    #   assert %Exd.Query{
    #     from: {"people", [%{"name" => "mads", "age" => 24}], []},
    #     select: %{
    #       age_times_four: {:multiply, [{:multiply, [{:binding, ["people", "age"]}, 2]}, 2]},
    #     }
    #   } ==
    #     from people in [%{"name" => "mads", "age" => 24}],
    #     select: %{
    #       age_times_four: multiply(multiply(people.age, 2), 2)
    #     }
    # end

    # test "it works with maps" do
    #   assert %Exd.Query{
    #     from: {"p", [%{"name" => "mads"}], []},
    #     select: {:interpolate, ["hello ?", {:binding, ["p", "name"]}]}
    #   } ==
    #     from p in [%{"name" => "mads"}],
    #     select: interpolate("hello ?", p.name)
    # end
  end

end
