defmodule Exd.Query.Builder.FromTest do
  use ExUnit.Case
  import Exd.Query.Builder.From
  doctest Exd.Query.Builder.From

  describe "from/3" do
    # test "it works for literals" do
    #   assert %Query{
    #     from: {"n", [1, 2, 3]}
    #   } ==
    #     from n in [1, 2, 3]
    # end

    # test "it works for variables" do
    #   list = [1, 2, 3]
    #   assert %Query{
    #     from: {"n", [1, 2, 3]}
    #   } ==
    #     from n in list
    # end

    # test "it works for list of maps" do
    #   assert %Query{
    #     from: {"p", [%{"name" => "mads"}]}
    #   } ==
    #     from p in [%{"name" => "mads"}]
    # end

  #   test "it with subquery" do
  #     q1 = from p in [1, 2, 3]
  #     q2 = from p in subquery(q1)

  #     assert %Query{
  #       from: {
  #         "p",
  #         {
  #           :subquery,
  #           [
  #             %Query{
  #               from: {"p", [1, 2, 3]}
  #             }
  #           ]
  #         }
  #       }
  #     } == q2
  #   end

  #   test "it with subqueries" do
  #     q1 = from a in [1, 2, 3]
  #     q2 = from b in [1, 2, 3]
  #     q3 = from c in subquery(q1, q2)

  #     assert %Query{
  #       from: {
  #         "c",
  #         {
  #           :subquery,
  #           [
  #             %Query{
  #               from: {"a", [1, 2, 3]}
  #             },
  #             %Query{
  #               from: {"b", [1, 2, 3]}
  #             }
  #           ]
  #         }
  #       }
  #     } == q3
  #   end

  #   test "it works for expressions" do
  #     assert %Query{
  #       from: {"r", {:fetch, ["https://coinmarketcap.com"]}}
  #     } ==
  #       from r in fetch("https://coinmarketcap.com")
  #   end
  end

end
