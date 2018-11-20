# defmodule Exd.Plugin.List.RangeTest do
#   use Exd.QueryCase
#   alias Exd.Repo

#   describe "range/3" do
#     test "it generates a range" do
#       assert [
#         %{number: 0},
#         %{number: 1},
#         %{number: 2}
#       ] ==
#         Repo.all(
#           from r in range(0, 2),
#           select: %{
#             number: unnest(r)
#           }
#         )
#     end
#   end

# end
