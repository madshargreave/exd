defmodule Exd.Plugin.IntegerTest do
  use Exd.PluginCase,
    plugin: Exd.Plugin.Integer

  describe "add/3" do
    test "it adds numbers" do
      assert 10 == Exd.Plugin.apply({:add, 5, 5})
    end
  end

  describe "subtract/3" do
    test "it subtracts numbers" do
      assert 0 == Exd.Plugin.apply({:subtract, 5, 5})
    end
  end

  describe "multiply/3" do
    test "it multiples numbers" do
      assert 25 == Exd.Plugin.apply({:multiply, 5, 5})
    end
  end

  describe "divide/3" do
    test "it divides numbers" do
      assert 1 == Exd.Plugin.apply({:divide, 5, 5})
    end
  end

end
