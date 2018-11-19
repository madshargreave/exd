# defmodule Exd.Interpreter.JoinTest do
#   use Exd.QueryCase
#   alias Exd.{Repo, Query}
#   doctest Exd.Interpreter.Where

#   describe "filtering" do
#     test "it filters results" do
#       assert [
#         %{name: "mads", role: "engineer", salary: 20000},
#         %{name: "jack", role: "engineer", salary: 20000},
#         %{name: "john", role: "manager", salary: 15000}
#       ] ==
#         Repo.all(
#           %Query{
#             from: {
#               :c,
#               [
#                 %{name: "mads", role: "engineer"},
#                 %{name: "jack", role: "engineer"},
#                 %{name: "john", role: "manager"}
#               ]
#             },
#             joins: [
#               %{
#                 from: {
#                   :s,
#                   [
#                     %{role: "engineer", salary: 20000},
#                     %{role: "manager", salary: 15000}
#                   ],
#                   []
#                 }
#               }
#             ],
#             select: %{
#               name: {:binding, [:c, :name]},
#               role: {:binding, [:c, :role]},
#               salary: {:binding, [:s, :salary]}
#             }
#           }
#         )
#     end
#   end
# end
