# defmodule Exd.Query.RewriterTest do
#   use ExUnit.Case

#   alias Exd.Query
#   alias Exd.Query.Rewriter

#   @people [
#     %{"first_name" => "jack", "last_name" => "doe"},
#     %{"first_name" => "john", "last_name" => "doe"}
#   ]

#   describe "rewriting" do
#     test "it works" do
#       assert [
#         %{"full_name" => "jack doe"},
#         %{"full_name" => "john doe"}
#       ] ==
#         Query.new
#         |> Query.from("people", @people)
#         |> Query.select(%{
#           "full_name" => "'{{people.first_name}} {{people.last_name}}'"
#         })
#         |> Query.to_list
#     end
#   end

# end
