defmodule Exd.QueryRunnerTest do
  use ExUnit.Case

  alias Exd.QueryRunner
  alias Exd.Query

  describe "stream/1" do
    test "it works with query literals" do
      query = %Query{from: {"numbers", [1, 2, 3]}}

      assert [1, 2, 3] ==
        query
        |> QueryRunner.stream
        |> Enum.sort
    end

    test "it works with query functions" do
      query = %Query{from: {"numbers", fn _context -> [1, 2, 3] end}}

      assert [1, 2, 3] ==
        query
        |> QueryRunner.stream
        |> Enum.sort
    end

    test "it works with query contexted functions" do
      query = %Query{
        from: {"people", [%{"name" => "mads", "country" => "denmark", "age" => 20}]},
        joins: [
          %{
            type: :inner,
            from: {"testing", fn context ->
              for document <- context,
                  i <- 0..2 do
                %{"name" => "denmark", "age_times_two" => document["people"]["age"] * i}
              end
            end},
            left_key: "people.country",
            right_key: "testing.name"
          }
        ],
        select: {"people.name", "people.country", "testing.age_times_two"}
      }

      assert [
        {"mads", "denmark", 0},
        {"mads", "denmark", 20},
        {"mads", "denmark", 40}
      ] ==
        query
        |> QueryRunner.stream
        |> Enum.sort
    end

    defmodule TestSource do
      use Exd.Source,
        provider: {Exd.Source.List, value: [1, 2, 3]}
    end

    test "it works with source modules" do
      query = %Query{from: {"numbers", TestSource}}

      assert [1, 2, 3] ==
        query
        |> QueryRunner.stream
        |> Enum.sort
    end

    defmodule AnyModule do

    end

    test "it throws on module without implementation" do
      query = %Query{from: {"numbers", AnyModule}}

      assert_raise Protocol.UndefinedError, fn ->
        query
        |> QueryRunner.stream
        |> Enum.sort
      end
    end

    test "it works with subqueries" do
      even = %Query{from: {"even", [2, 4, 6]}}
      odd = %Query{from: {"odd", [1, 3, 5]}}
      query = %Query{from: {"numbers", [even, odd]}}

      assert [1, 2, 3, 4, 5, 6] ==
        query
        |> QueryRunner.stream
        |> Enum.sort
    end

    test "it works with joins" do
      query = %Query{
        from: {"people", [%{"name" => "mads", "country" => "denmark"}]},
        joins: [
          %{
            type: :inner,
            from: {"countries", [%{"name" => "denmark", "population" => 5_000_000}]},
            left_key: "people.country",
            right_key: "countries.name"
          }
        ],
        select: {"people.name", "people.country", "countries.population"}
      }

      assert [{"mads", "denmark", 5_000_000}] ==
        query
        |> QueryRunner.stream
        |> Enum.sort
    end
  end

  test "it works with tuple selection" do
    query = %Query{
      from: {"people", [%{"name" => "mads", "country" => "denmark"}]},
      select: {"people.name", "people.country"}
    }

    assert [{"mads", "denmark"}] ==
      query
      |> QueryRunner.stream
      |> Enum.sort
  end

  test "it works with map selection" do
    query = %Query{
      from: {"people", [%{"name" => "mads", "country" => "denmark"}]},
      select: %{
        name: "people.name",
        country: "people.country"
      }
    }

    assert [%{name: "mads", country: "denmark"}] ==
      query
      |> QueryRunner.stream
      |> Enum.sort
  end

  test "it works with into statement" do
    parent = self()

    assert [
      {"jack", "denmark"},
      {"mads", "denmark"}
    ] ==
      %Query{
        from: {"people", [
          %{"name" => "mads", "country" => "denmark"},
          %{"name" => "jack", "country" => "denmark"}
        ]},
        select: {"people.name", "people.country"},
        into: fn document -> send parent, {:received, document} end
      }
      |> QueryRunner.stream
      |> Enum.sort

    assert_receive {:received, {"mads", "denmark"}}
    assert_receive {:received, {"jack", "denmark"}}
  end

  defmodule AnotherEmptyTestSource do
    use Exd.Source,
      provider: {Exd.Source.List, value: [1, 2, 3]}
  end

  test "it works when filtering on a joined value" do
    query = %Query{
      from: {"people", [
        %{"name" => "mads", "country" => "denmark"},
        %{"name" => "jack", "country" => "denmark"}
      ]},
      joins: [
        %{
          type: :left_outer,
          from: {"existing", [
            %{"name" => "jack", "country" => "denmark"}
          ]},
          left_key: "people.name",
          right_key: "existing.name"
        }
      ],
      where: [
        {"existing.name", :=, nil}
      ],
      select: %{
        name: "people.name",
        country: "people.country"
      }
    }

    assert [
      %{name: "mads", country: "denmark"}
    ] ==
      query
      |> QueryRunner.stream
      |> Enum.sort
  end

  test "it works with external processes" do
    {:ok, people_agent} =
      Agent.start_link fn -> [
        %{"name" => "jack", "country" => "denmark"},
        %{"name" => "mads", "country" => "denmark"},
        %{"name" => "jack", "country" => "denmark"}
      ] end
    {:ok, existing_agent} = Agent.start_link fn -> [] end

    get_people = fn _document -> Agent.get(people_agent, &(&1)) end
    get_existing = fn _document -> Agent.get(existing_agent, &(&1)) end
    insert_into_people = fn document ->  Agent.update(existing_agent, &([document | &1])) end

    query = %Query{
      from: {"people", get_people},
      joins: [
        %{
          type: :left_outer,
          from: {"existing", get_existing},
          left_key: "people.name",
          right_key: "existing.name"
        }
      ],
      where: [
        {"existing.name", :=, nil}
      ],
      distinct: "people.name",
      select: %{
        "name" => "people.name",
        "country" => "people.country"
      },
      into: insert_into_people
    }

    assert [
      %{"name" => "jack", "country" => "denmark"},
      %{"name" => "mads", "country" => "denmark"}
    ] == query
    |> QueryRunner.stream
    |> Enum.sort

    Agent.update(people_agent, fn list -> [%{"name" => "john", "country" => "denmark"} | list] end)

    assert [
      %{"name" => "john", "country" => "denmark"}
    ] == query
    |> QueryRunner.stream
    |> Enum.sort
  end

end
