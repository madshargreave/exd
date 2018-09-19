# defmodule Exd.Source.ListTest do
#   use ExUnit.Case

#   alias Exd.Query
#   alias Exd.Repo
#   alias Exd.Source.List, as: ListAdapter

#   describe "from/1" do
#     test "it returns preconfigured value" do
#       assert [
#         %{"title" => "job 2", "salary" => 15000},
#         %{"title" => "job 3", "salary" => 15000}
#       ] == Query.new
#       |> Query.from(
#         "jobs",
#         [
#           %{"title" => "job 1", "salary" => 10000},
#           %{"title" => "job 2", "salary" => 15000},
#           %{"title" => "job 3", "salary" => 15000}
#         ]
#       )
#       |> Query.where("jobs.salary", :>, 12500)
#       |> Query.select("jobs")
#       |> Repo.stream
#       |> Enum.sort
#     end
#   end
# end
