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
        ]
      })
    end
  end
end
