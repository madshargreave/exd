# defmodule Exd.Parser.MapTest do
#   use ExUnit.Case
#   alias Exd.Query

#   describe "parse/1" do
#     test "it returns query as is" do
#       assert {
#         :ok,
#         %Query{
#           from: {
#             "jobs",
#             {
#               Exd.Source.List,
#                 value: [
#                   %{"name" => "job 1", "salary" => 20000},
#                   %{"name" => "job 2", "salary" => 30000},
#                   %{"name" => "job 3", "salary" => 40000}
#                 ]
#             }
#           },
#           joins: [
#             %{
#               type: :left_outer,
#               from: {
#                 "countries",
#                 {
#                   Exd.Source.List,
#                     value: [
#                       %{"name" => "denmark", "code" => "dk"}
#                     ]
#                 }
#               },
#               left_key: "jobs.country_code",
#               right_key: "countries.code"
#             }
#           ],
#           where: [
#             {"jobs.salary", :>, 25000}
#           ],
#           select: %{
#             "title" => "jobs.title",
#             "salary" => "jobs.salary"
#           },
#           into: [
#             {
#               Exd.Sink.Logger,
#                 []
#             },
#             {
#               Exd.Sink.SQL,
#                 database: "harvest_dev",
#                 datakey: "title",
#                 hostname: "localhost",
#                 max_demand: 5,
#                 password: "postgres",
#                 username: "postgres"
#             }
#           ]
#         }
#       } = Exd.Parseable.parse(%{
#         "sources" => %{
#           "countries" => %{
#             "type" => "list",
#             "config" => %{
#               "value" => [
#                 %{"name" => "denmark", "code" => "dk"}
#               ]
#             }
#           },
#           "jobs" => %{
#             "type" => "list",
#             "config" => %{
#               "value" => [
#                 %{"name" => "job 1", "salary" => 20000, "country_code" => "dk"},
#                 %{"name" => "job 2", "salary" => 30000, "country_code" => "dk"},
#                 %{"name" => "job 3", "salary" => 40000, "country_code" => "dk"}
#               ]
#             }
#           }
#         },
#         "from" => %{
#           "name" => "jobs",
#           "source" => "jobs"
#         },
#         "joins" => [
#           %{
#             "type" => "left_outer",
#             "from" => %{
#               "name" => "countries",
#               "source" => "countries"
#             },
#             "left_key" => "jobs.country_code",
#             "right_key" => "countries.code"
#           }
#         ],
#         "where" => [
#           %{
#             "field" => "jobs.salary",
#             "relation" => "greater_than",
#             "value" => 25000
#           }
#         ],
#         "select" => %{
#           "title" => "jobs.title",
#           "salary" => "jobs.salary"
#         },
#         "into" => [
#           %{
#             "type" => "logger",
#             "config" => %{}
#           },
#           %{
#             "type" => "sql",
#             "config" => %{
#               "hostname" => "localhost",
#               "database" => "harvest_dev",
#               "username" => "postgres",
#               "password" => "postgres",
#               "datakey" => "title",
#               "max_demand" => 5
#             }
#           }
#         ]
#       })
#     end
#   end
# end
