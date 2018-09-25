# defmodule Exd.Interpreter.IntoTest do
#   use ExUnit.Case

#   alias Exd.{Query, Record}
#   alias Exd.Interpreter.Planner
#   alias Exd.Sink.Test, as: TestSink

#   describe "into/2" do
#     test "it returns preconfigured value" do
#       assert [
#         {"bitcoin"},
#         {"ethereum"},
#         {"ripple"}
#       ] ==
#         Query.new
#         |> Query.from(
#           "coins",
#           [
#             %{"name" => "bitcoin"},
#             %{"name" => "ethereum"},
#             %{"name" => "ripple"}
#           ]
#         )
#         |> Query.select({"coins.name"})
#         |> Query.into(
#           "test",
#           {
#             TestSink,
#               parent_pid: self()
#           }
#         )
#         |> Planner.plan
#         |> Enum.sort_by(& elem(&1, 0))

#       assert_receive {:results, [{"bitcoin"}]}
#       assert_receive {:results, [{"ethereum"}]}
#       assert_receive {:results, [{"ripple"}]}
#     end
#   end
# end
