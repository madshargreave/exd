# defmodule Exd.Runner.JoinTest do
#   use ExUnit.Case

#   alias Exd.{Query, Record}
#   alias Exd.Runner.Planner
#   alias Exd.Record

#   describe "join/3" do
#     test "it works with queries" do
#       employment =
#         Query.new
#         |> Query.from(
#           "employment",
#           fn %{"name" => name} = _args ->
#             case name do
#               "jack" -> [%{"role" => "engineer"}]
#               "john" -> [%{"role" => "designer"}]
#             end
#           end
#         )
#         |> Query.select("people")

#       assert [
#         %{"name" => "bitcoin"},
#         %{"name" => "ethereum"},
#         %{"name" => "ripple"}
#       ] ==
#         Query.new
#         |> Query.from(
#           "people",
#           [
#             %{"name" => "jack", "age" => 25},
#             %{"name" => "john", "age" => 25}
#           ]
#         )
#         |> Query.join("employment", employment, name: "people.name")
#         |> Query.select([
#           "people",
#           "employment"
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
