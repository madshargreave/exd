defmodule Exd.Query.BuilderTest do
  use ExUnit.Case
  import Exd.Query.Builder

  describe "building" do
    test "from" do
      assert %Exd.Query{
        from: {"numbers", [1, 2, 3], []}
      } == from(numbers in [1, 2, 3])
    end

    test "select" do
      assert %Exd.Query{
        from: {"numbers", [1, 2, 3], []},
        select: "numbers"
      } == from(numbers in [1, 2, 3], select: numbers)
    end
  end

end
