defmodule Exd.Query.BuilderTest do
  use ExUnit.Case
  import Exd.Query.Builder

  describe "from/2" do
    test "it for lists" do
      assert %Exd.Query{
        from: {"numbers", [1, 2, 3], []}
      } ==
        from numbers in [1, 2, 3]
    end

    test "it works for expressions" do
      assert %Exd.Query{
        from: {"numbers", {:fetch, "'https://coinmarketcap.com'"}, []}
      } ==
        from numbers in fetch("https://coinmarketcap.com")
    end
  end

  describe "select/1" do
    test "it works when selecting binding" do
      assert %Exd.Query{
        from: {"numbers", [1, 2, 3], []},
        select: "numbers"
      } == from(numbers in [1, 2, 3], select: numbers)
    end

    test "it works when selecting map" do
      assert %Exd.Query{
        from: {"people", [%{"name" => "mads", "age" => 24}], []},
        select: %{
          name: "people.name",
          age: "people.age"
        }
      } ==
        from people in [%{"name" => "mads", "age" => 24}],
        select: %{
          name: people.name,
          age: people.age
        }
    end

    test "it works when selecting a function" do
      assert %Exd.Query{
        from: {"people", [%{"name" => "mads", "age" => 24}], []},
        select: %{
          name: {:interpolate, "'hello ?'", "people.name"},
        }
      } ==
        from people in [%{"name" => "mads", "age" => 24}],
        select: %{
          name: interpolate("hello ?", people.name)
        }
    end

    test "it works with nested function expressions" do
      assert %Exd.Query{
        from: {"people", [%{"name" => "mads", "age" => 24}], []},
        select: %{
          age_times_four: {:multiply, {:multiply, "people.age", 2}, 2},
        }
      } ==
        from people in [%{"name" => "mads", "age" => 24}],
        select: %{
          age_times_four: multiply(multiply(people.age, 2), 2)
        }
    end
  end

end
