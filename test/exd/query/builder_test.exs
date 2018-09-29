defmodule Exd.Query.BuilderTest do
  use ExUnit.Case
  import Exd.Query.Builder

  describe "from/2" do
    test "it for lists" do
      assert %Exd.Query{
        from: {"n", [1, 2, 3]}
      } ==
        from n in [1, 2, 3]
    end

    test "it works for variables" do
      my_list = [1, 2, 3]
      assert %Exd.Query{
        from: {"n", [1, 2, 3]}
      } ==
        from n in my_list
    end

    test "it works for subqueries" do
      inner = from inner in [1, 2, 3]
      assert %Exd.Query{
        from: {"outer", {:subquery, [%Exd.Query{from: {"inner", [1, 2, 3]}}]}}
      } ==
        from outer in subquery(inner)
    end

    test "it works for expressions" do
      assert %Exd.Query{
        from: {"r", {:fetch, ["https://coinmarketcap.com"]}}
      } ==
        from r in fetch("https://coinmarketcap.com")
    end
  end

  describe "select/1" do
    test "it works when selecting binding" do
      assert %Exd.Query{
        from: {"n", [1, 2, 3]},
        select: {:binding, ["n"]}
      } ==
        from n in [1, 2, 3],
        select: n
    end

    test "it works when selecting binding with variables" do
      my_list = [1, 2, 3]
      assert %Exd.Query{
        from: {"n", [1, 2, 3]},
        select: {:binding, ["n"]}
      } ==
        from n in my_list,
        select: n
    end

    test "it works when selecting map" do
      assert %Exd.Query{
        from: {"people", [%{"name" => "mads", "age" => 24}]},
        select: %{
          name: {:binding, ["people", "name"]},
          age: {:binding, ["people", "age"]}
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
        from: {"people", [%{"name" => "mads", "age" => 24}]},
        select: %{
          name: {:interpolate, ["hello ?", {:binding, ["people", "name"]}]},
        }
      } ==
        from people in [%{"name" => "mads", "age" => 24}],
        select: %{
          name: interpolate("hello ?", people.name)
        }
    end

    test "it works with nested function expressions" do
      assert %Exd.Query{
        from: {"people", [%{"name" => "mads", "age" => 24}]},
        select: %{
          age_times_four: {:multiply, [{:multiply, [{:binding, ["people", "age"]}, 2]}, 2]},
        }
      } ==
        from people in [%{"name" => "mads", "age" => 24}],
        select: %{
          age_times_four: multiply(multiply(people.age, 2), 2)
        }
    end

    test "it works with maps" do
      assert %Exd.Query{
        from: {"p", [%{"name" => "mads"}]},
        select: {:interpolate, ["hello ?", {:binding, ["p", "name"]}]}
      } ==
        from p in [%{"name" => "mads"}],
        select: interpolate("hello ?", p.name)
    end

    test "it works with interpolation" do
      assert %Exd.Query{
        from: {"p", [%{"name" => "mads"}]},
        select: %{
          name: {:binding, ["p", "name"]},
          age: 25
        }
      } ==
        from p in [%{"name" => "mads"}],
        select: %{
          name: p.name,
          age: 25
        }
    end
  end

end
