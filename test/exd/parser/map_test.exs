defmodule Exd.Parser.MapTest do
  use ExUnit.Case
  alias Exd.Query

  describe "parse/1" do
    test "it returns query as is" do
      assert {
        :ok,
        %Query{
          from: {
            "jobs",
            {
              Exd.Source.List,
                value: [
                  %{"name" => "job 1", "salary" => 20000},
                  %{"name" => "job 2", "salary" => 30000},
                  %{"name" => "job 3", "salary" => 40000}
                ]
            }
          },
          where: [
            {"jobs.salary", :>, 25000}
          ],
          select: %{
            "title" => "jobs.title",
            "salary" => "jobs.salary"
          },
          into: [
            {
              Exd.Sink.SQL,
                database: "harvest_dev",
                datakey: "title",
                hostname: "localhost",
                max_demand: 5,
                password: "postgres",
                username: "postgres"
            }
          ]
        }
      } = Exd.Parseable.parse(%{
        "sources" => %{
          "jobs" => %{
            "type" => "list",
            "config" => %{
              "value" => [
                %{"name" => "job 1", "salary" => 20000},
                %{"name" => "job 2", "salary" => 30000},
                %{"name" => "job 3", "salary" => 40000}
              ]
            }
          }
        },
        "from" => %{
          "name" => "jobs",
          "source" => "jobs"
        },
        "where" => [
          %{
            "field" => "jobs.salary",
            "relation" => "greater_than",
            "value" => 25000
          }
        ],
        "select" => %{
          "title" => "jobs.title",
          "salary" => "jobs.salary"
        },
        "into" => [
          %{
            "type" => "sql",
            "config" => %{
              "hostname" => "localhost",
              "database" => "harvest_dev",
              "username" => "postgres",
              "password" => "postgres",
              "datakey" => "title",
              "max_demand" => 5
            }
          }
        ]
      })
    end
  end
end
