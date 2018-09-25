defmodule Exd.Query.Builder.WhereTest do
  use ExUnit.Case
  import Exd.Query.Builder.Where
  doctest Exd.Query.Builder.Where
#   import Exd.Query.Builder
#   use ExUnit.Case

#   alias Exd.Query

#   describe "selecting" do
#     test "it works for literals" do
#       assert %Query{
#         from: {"numbers", [1, 2, 3], []},
#         select: "numbers"
#       } ==
#         from numbers in [1, 2, 3],
#         select: numbers
#     end

#     test "it works for maps" do
#       assert %Query{
#         from: {"numbers", [1, 2, 3], []},
#         select: %{
#           value: "numbers"
#         }
#       } ==
#         from numbers in [1, 2, 3],
#         select: %{
#           value: numbers
#         }
#     end

#     test "it works for functions" do
#       assert %Query{
#         from: {"n", [1, 2, 3], []},
#         select: {:add, "n", 1}
#       } ==
#         from n in [1, 2, 3],
#         select: add(n, 1)
#     end

#     test "it works for functions only bindings" do
#       assert %Query{
#         from: {"n", [1, 2, 3], []},
#         select: {:unnest, "n"}
#       } ==
#         from n in [1, 2, 3],
#         select: unnest(n)
#     end
#   end

end
