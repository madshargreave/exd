# defmodule Exd.Plugin.String.ReplaceTest do
#   use Exd.QueryCase
#   alias Exd.Repo

#   describe "replace/3" do
#     test "it replaces strings" do
#       assert "hello there" ==
#         Repo.first(
#           from g in ["hello.there"],
#           select: replace(g, ".", " ")
#         )
#     end
#   end

# end
