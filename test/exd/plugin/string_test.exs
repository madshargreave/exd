defmodule Exd.Plugin.StringTest do
  use ExUnit.Case

  alias Exd.Query
  alias Exd.Plugin

  defmodule MyPlugin do
    use Exd.Plugin.String
  end

  describe "replace/3" do
    test "it replaces strings" do
      assert "hello there" == MyPlugin.__helper__({:replace, "hello.there", ".", " "})
    end
  end

  describe "regex/2" do
    test "it works when regex is a string" do
      assert "hello" == MyPlugin.__helper__({:regex, "hello.there", "^(hello)"})
    end

    test "it works when regex primitive" do
      assert "hello" == MyPlugin.__helper__({:regex, "hello.there", ~r/^(hello)/})
    end
  end

  describe "trim/1" do
    test "it trims string" do
      assert "hello" == MyPlugin.__helper__({:trim, " hello "})
    end
  end

  describe "downcase/1" do
    test "it downcases string" do
      assert "hello" == MyPlugin.__helper__({:downcase, "HELLO"})
    end
  end

end
