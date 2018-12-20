# defmodule Exd.Query.Builder.FromTest do
#   use ExUnit.Case
#   import Exd.Query.Builder

#   describe "from/2" do
#     test "it for lists" do
#       assert %Exd.Query{
#         from: {:n, [1, 2, 3]}
#       } ==
#         from n in [1, 2, 3]
#     end

#     test "it works for variables" do
#       my_list = [1, 2, 3]
#       assert %Exd.Query{
#         from: {:n, [1, 2, 3]}
#       } ==
#         from n in my_list
#     end

#     test "it works for subqueries" do
#       inner = from inner in [1, 2, 3]
#       assert %Exd.Query{
#         from: {:outer, {:subquery, [%Exd.Query{from: {:inner, [1, 2, 3]}}]}}
#       } ==
#         from outer in subquery(inner)
#     end

#     test "it works for expressions" do
#       assert %Exd.Query{
#         from: {:r, {:fetch, ["https://coinmarketcap.com"]}}
#       } ==
#         from r in fetch("https://coinmarketcap.com")
#     end
#   end

# end
