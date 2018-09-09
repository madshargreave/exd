defmodule Exd.SinkTest do
  use ExUnit.Case

  alias Exd.Query
  alias Exd.Repo
  alias Exd.Source.List, as: ListSource
  alias Exd.Sink.Logger, as: LoggerSink
  alias Exd.Sink.Test, as: TestSink

  describe "into/3" do
    test "it works with multiple sinks" do
      Query.new
      |> Query.from(
        "jobs",
        {
          ListSource,
            value: [
              %{"title" => "job 1", "salary" => 10000},
              %{"title" => "job 2", "salary" => 15000},
              %{"title" => "job 3", "salary" => 15000}
            ]
        }
      )
      |> Query.into(TestSink, parent_pid: self(), max_demand: 5)
      |> Query.into(TestSink, parent_pid: self(), max_demand: 5)
      |> Repo.run

      assert_receive {
        :results,
        [
          %{"title" => "job 1", "salary" => 10000},
          %{"title" => "job 2", "salary" => 15000},
          %{"title" => "job 3", "salary" => 15000}
        ]
      }

      assert_receive {
        :results,
        [
          %{"title" => "job 1", "salary" => 10000},
          %{"title" => "job 2", "salary" => 15000},
          %{"title" => "job 3", "salary" => 15000}
        ]
      }
    end
  end
end
