# defmodule Exd.Sink.TestTest do
#   use ExUnit.Case, async: false

#   alias Exd.Query
#   alias Exd.Repo
#   alias Exd.Source.List, as: ListSource
#   alias Exd.Sink.Test, as: TestSink

#   @source {
#     ListSource,
#       value: [
#         %{"title" => "job 1", "salary" => 10000},
#         %{"title" => "job 2", "salary" => 15000},
#         %{"title" => "job 3", "salary" => 15000}
#       ]
#   }

#   describe "from/1" do
#     test "it returns preconfigured value" do
#       Query.new
#       |> Query.from(@source)
#       |> Query.into(TestSink, parent_pid: self())
#       |> Repo.run

#       assert_receive {
#         :results,
#         [
#           %{"title" => "job 1", "salary" => 10000},
#           %{"title" => "job 2", "salary" => 15000},
#           %{"title" => "job 3", "salary" => 15000}
#         ]
#       }
#     end

#     test "it accepts genstage configuration option" do
#       Query.new
#       |> Query.from(@source)
#       |> Query.into(TestSink, parent_pid: self(), max_demand: 3)
#       |> Repo.run

#       assert_receive {
#         :results,
#         [
#           %{"title" => "job 1", "salary" => 10000},
#           %{"title" => "job 2", "salary" => 15000}
#         ]
#       }

#       assert_receive {
#         :results,
#         [
#           %{"title" => "job 3", "salary" => 15000}
#         ]
#       }
#     end
#   end
# end
