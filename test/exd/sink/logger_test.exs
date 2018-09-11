# defmodule Exd.Sink.LoggerTest do
#   use ExUnit.Case

#   alias Exd.Query
#   alias Exd.Repo
#   alias Exd.Source.List, as: ListSource
#   alias Exd.Sink.Logger, as: LoggerSink

#   describe "from/1" do
#     test "it returns preconfigured value" do
#       Query.new
#       |> Query.from(
#         "jobs",
#         {
#           ListSource,
#             value: [
#               %{"title" => "job 1", "salary" => 10000},
#               %{"title" => "job 2", "salary" => 15000},
#               %{"title" => "job 3", "salary" => 15000}
#             ]
#         }
#       )
#       |> Query.into(LoggerSink, max_demand: 5)
#       |> Repo.run
#     end
#   end
# end
