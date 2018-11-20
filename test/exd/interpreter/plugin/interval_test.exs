# defmodule Exd.Plugin.IntervalTest do
#   use Exd.QueryCase

#   describe "interval/1" do
#     test "it emits events every interval" do
#       parent = self()
#       Exd.Repo.start_link(
#         from i in interval(100),
#         select: i,
#         into: &send(parent, &1.value)
#       )
#       assert_receive %NaiveDateTime{} = _ts, 500
#       assert_receive %NaiveDateTime{} = _ts, 500
#       assert_receive %NaiveDateTime{} = _ts, 500
#     end
#   end
# end
