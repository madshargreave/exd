# defmodule Exd.Query.Builder.JoinTest do
#   use ExUnit.Case
#   import Exd.Query.Builder

#   describe "from/2" do
#     test "it for lists" do
#       assert %Exd.Query{
#         from: {:a, [1, 2, 3]},
#         joins: [
#           %{
#             from: {:b, [1 ,2 ,3]},
#             on: [{:binding, [:a]}, :=, {:binding, [:b]}]
#           }
#         ]
#       } ==
#         from a in [1, 2, 3],
#         join: b in [1, 2, 3], on: a = b
#     end
#   end
# end
