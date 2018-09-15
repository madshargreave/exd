# defmodule Exd.Source.StoreTest do
#   use ExUnit.Case

#   alias Exd.Query
#   alias Exd.Repo
#   alias Exd.Source.List, as: ListSource
#   alias Exd.Source.Store, as: StoreSource
#   alias Exd.Store.Memory, as: MemoryStore

#   describe "from/1" do
#     test "it returns preconfigured value" do
#       assert [
#         {"created", "job 2", 15000},
#         {"created", "job 3", 15000}
#       ] ==
#         Query.new
#         |> Query.from(
#           "jobs",
#           {
#             ListSource,
#               value: [
#                 %{"title" => "job 1", "salary" => 10000, "country_code" => "dk"},
#                 %{"title" => "job 2", "salary" => 15000, "country_code" => "dk"},
#                 %{"title" => "job 3", "salary" => 15000, "country_code" => "dk"}
#               ]
#           }
#         )
#         |> Query.join(
#           :left_outer,
#           "existing_jobs",
#           {
#             StoreSource,
#               adapter: {
#                 MemoryStore,
#                   name: :my_store,
#                   primary_key: "title",
#                   initial_state: [
#                     %{"title" => "job 1", "salary" => 10000, "country_code" => "dk"}
#                   ]
#               }
#           },
#           "jobs.title",
#           "existing_jobs.title"
#         )
#         |> Query.where("jobs.title", :=, nil)
#         |> Query.select({"'created'", "jobs.title", "jobs.salary"})
#         |> Repo.stream
#         |> Enum.sort
#     end
#   end
# end
