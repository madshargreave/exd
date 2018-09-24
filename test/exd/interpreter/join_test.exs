# defmodule Exd.Interpreter.JoinTest do
#   use ExUnit.Case

#   alias Exd.{Query, Record}
#   alias Exd.Interpreter.Planner
#   alias Exd.Record

#   describe "join/3" do
#     test "it works with queries" do
#       numbers =
#         Query.new
#         |> Query.from("numbers", {:range, 0, 2})
#         |> Query.select(%{
#           "number" => {:unnest, "numbers"}
#         })

#       assert [
#         %{"name" => "jack", "number" => 0},
#         %{"name" => "jack", "number" => 1},
#         %{"name" => "jack", "number" => 2},
#         %{"name" => "john", "number" => 0},
#         %{"name" => "john", "number" => 1},
#         %{"name" => "john", "number" => 2}
#       ] ==
#         Query.new
#         |> Query.from(
#           "people",
#           [
#             %{"name" => "jack"},
#             %{"name" => "john"}
#           ]
#         )
#         |> Query.join("numbers", numbers, test: "people.name")
#         |> Query.select([
#           "people",
#           "numbers"
#         ])
#         |> Query.to_list
#       end
#     end
#   #   test "it returns preconfigured value" do
#   #     assert [
#   #       %Record{value: %{
#   #         "coins" => %{"name" => "bitcoin"},
#   #         "length" => 7
#   #       }},
#   #       %Record{value: %{
#   #         "coins" => %{"name" => "ethereum"},
#   #         "length" => 8
#   #       }},
#   #       %Record{value: %{
#   #         "coins" => %{"name" => "ripple"},
#   #         "length" => 6
#   #       }}
#   #     ] =
#   #       Query.new
#   #       |> Query.from(
#   #         "coins",
#   #         [
#             # %{"name" => "bitcoin"},
#             # %{"name" => "ethereum"},
#             # %{"name" => "ripple"}
#   #         ]
#   #       )
#   #       |> Query.join(
#   #         "length",
#   #         fn records ->
#   #           for record <- records, do: String.length(record.value["coins"]["name"])
#   #         end
#   #       )
#   #       |> Planner.plan
#   #       |> Enum.sort_by& get_in(&1.value, ~w(coins name))
#   #   end
#   # end
# end
