# defmodule Exd.Query.Builder.WhereTest do
#   use ExUnit.Case
#   import Exd.Query.Builder

#   describe "where/3" do
#     test "it works with raw binding" do
#       assert %Exd.Query{
#         from: {:n, [1, 2, 3]},
#         where: [
#           {{:binding, [:n]}, :>, 100}
#         ]
#       } ==
#         from n in [1, 2, 3],
#         where: n > 100
#     end

#     test "it works with binding fields" do
#       assert %Exd.Query{
#         from: {:n, [%{number: 1}, %{number: 2}, %{number: 3}]},
#         where: [
#           {{:binding, [:n, :number]}, :>, 100}
#         ]
#       } ==
#         from n in [%{number: 1}, %{number: 2}, %{number: 3}],
#         where: n.number > 100
#     end

#     test "it works with binding on either side" do
#       assert %Exd.Query{
#         from: {:n, [%{number: 1}, %{number: 2}, %{number: 3}]},
#         where: [
#           {100, :<, {:binding, [:n, :number]}}
#         ]
#       } ==
#         from n in [%{number: 1}, %{number: 2}, %{number: 3}],
#         where: 100 < n.number
#     end

#     test "it works with functions" do
#       assert %Exd.Query{
#         from: {:n, [1, 2, 3]},
#         where: [
#           {{:add, [{:binding, [:n]}, 2]}, :>, 4}
#         ]
#       } ==
#         from n in [1, 2, 3],
#         where: add(n, 2) > 4
#     end

#     test "it works with multiple where clauses" do
#       assert %Exd.Query{
#         from: {:n, [1, 2, 3]},
#         where: [
#           {{:binding, [:n]}, :>, 5},
#           {{:binding, [:n]}, :<, 10}
#         ]
#       } ==
#         from n in [1, 2, 3],
#         where: n > 5,
#         where: n < 10
#     end

#     test "it works with AND" do
#       assert %Exd.Query{
#         from: {:n, [1, 2, 3]},
#         where: [
#           {{:binding, [:n]}, :>, 5},
#           {{:binding, [:n]}, :<, 10}
#         ]
#       } ==
#         from n in [1, 2, 3],
#         where: n > 5 and n < 10
#     end

#   end

# end
