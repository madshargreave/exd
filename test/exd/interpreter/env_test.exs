# defmodule Exd.Interpreter.EnvTest do
#   use Exd.PluginCase,
#     plugin: Exd.Plugin.List

#   alias Exd.Query
#   alias Exd.Repo

#   describe "env/2" do
#     test "it when selecting" do
#       assert [
#         %{"id" => 1, "magic" => 123},
#         %{"id" => 2, "magic" => 123}
#       ] ==
#         Query.new
#         |> Query.set("MAGIC", 123)
#         |> Query.from(
#           "numbers",
#           [
#             %{"id" => 1},
#             %{"id" => 2}
#           ]
#         )
#         |> Query.select(%{
#           "id" => "numbers.id",
#           "magic" => {:arg, "MAGIC"}
#         })
#         |> Query.to_list
#     end

#     test "it when joining" do
#       range =
#         Query.new
#         |> Query.from("numbers", {:range, 0, {:arg, :max}})
#         |> Query.select(%{
#           "number" => {:unnest, "numbers"}
#         })

#       assert [
#         %{"id" => 1, "number" => 0},
#         %{"id" => 1, "number" => 1},
#         %{"id" => 1, "number" => 2},
#         %{"id" => 2, "number" => 0},
#         %{"id" => 2, "number" => 1},
#         %{"id" => 2, "number" => 2}
#       ] ==
#         Query.new
#         |> Query.from(
#           "numbers",
#           [
#             %{"id" => 1},
#             %{"id" => 2}
#           ]
#         )
#         |> Query.join("joined", range, max: 2)
#         |> Query.select([
#           "numbers",
#           "joined"
#         ])
#         |> Query.to_list
#     end
#   end

# end
