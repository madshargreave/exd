# defmodule Exd.Interpreter.JoinTest do
#   use Exd.QueryCase
#   alias Exd.{Repo, Query}
#   doctest Exd.Interpreter.Where

#   describe "filtering" do
#     test "it filters results" do
#       assert [
#         %{name: "bitcoin", status: 200},
#         %{name: "ethereum", status: 200},
#         %{name: "ripple", status: 200}
#       ] ==
#         Repo.all(
#           %Query{
#             from: {
#               :c,
#               [
#                 %{name: "bitcoin"},
#                 %{name: "ethereum"},
#                 %{name: "ripple"}
#               ]
#             },
#             joins: [
#               %{
#                 from: {
#                   :s,
#                   {
#                     :fetch,
#                       [
#                         {
#                           :interpolate,
#                           [
#                             "https://coinmarketcap.com/currencies/?/",
#                             {:binding, [:c, :name]}
#                           ]
#                         }
#                       ]
#                   },
#                   []
#                 }
#               }
#             ],
#             select: %{
#               name: {:binding, [:c, :name]},
#               status: {:binding, [:s, :status]}
#             }
#           }
#         )
#     end
#   end
# end
