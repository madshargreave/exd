# defmodule Exd.Query.Builder.SelectTest do
#   use ExUnit.Case
#   import Exd.Query.Builder

#   describe "select/1" do
#     test "it works when selecting binding" do
#       assert %Exd.Query{
#         from: {:n, [1, 2, 3]},
#         select: {:binding, [:n]}
#       } ==
#         from n in [1, 2, 3],
#         select: n
#     end

#     test "it works when selecting binding with variables" do
#       my_list = [1, 2, 3]
#       assert %Exd.Query{
#         from: {:n, [1, 2, 3]},
#         select: {:binding, [:n]}
#       } ==
#         from n in my_list,
#         select: n
#     end

#     test "it works when selecting map" do
#       assert %Exd.Query{
#         from: {:p, [%{"name" => "mads", "age" => 24}]},
#         select: %{
#           name: {:binding, [:p, :name]},
#           age: {:binding, [:p, :age]}
#         }
#       } ==
#         from p in [%{"name" => "mads", "age" => 24}],
#         select: %{
#           name: p.name,
#           age: p.age
#         }
#     end

#     test "it works when selecting a function" do
#       assert %Exd.Query{
#         from: {:p, [%{"name" => "mads", "age" => 24}]},
#         select: %{
#           name: {:interpolate, ["hello ?", {:binding, [:p, :name]}]},
#         }
#       } ==
#         from p in [%{"name" => "mads", "age" => 24}],
#         select: %{
#           name: interpolate("hello ?", p.name)
#         }
#     end

#     test "it works with nested function expressions" do
#       assert %Exd.Query{
#         from: {:p, [%{"name" => "mads", "age" => 24}]},
#         select: %{
#           age_times_four: {:multiply, [{:multiply, [{:binding, [:p, :age]}, 2]}, 2]},
#         }
#       } ==
#         from p in [%{"name" => "mads", "age" => 24}],
#         select: %{
#           age_times_four: multiply(multiply(p.age, 2), 2)
#         }
#     end

#     test "it works with maps" do
#       assert %Exd.Query{
#         from: {:p, [%{"name" => "mads"}]},
#         select: {:interpolate, ["hello ?", {:binding, [:p, :name]}]}
#       } ==
#         from p in [%{"name" => "mads"}],
#         select: interpolate("hello ?", p.name)
#     end

#     test "it works with interpolation" do
#       assert %Exd.Query{
#         from: {:p, [%{"name" => "mads"}]},
#         select: %{
#           name: {:binding, [:p, :name]},
#           age: 25
#         }
#       } ==
#         from p in [%{"name" => "mads"}],
#         select: %{
#           name: p.name,
#           age: 25
#         }
#     end
#   end

# end
