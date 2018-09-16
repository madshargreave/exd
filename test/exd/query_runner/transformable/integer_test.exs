defmodule Exd.Transformable.IntegerTest do
  use ExUnit.Case
  alias Exd.Transformable

  describe "add" do
    test "it adds numbers" do
      assert 10 == Transformable.transform(5, {:add, 5})
    end
  end

  describe "subtract" do
    test "it subtracts numbers" do
      assert 5 == Transformable.transform(10, {:subtract, 5})
    end
  end

  describe "multipy" do
    test "it multiplies numbers" do
      assert 10 == Transformable.transform(2, {:multiply, 5})
    end
  end

end
