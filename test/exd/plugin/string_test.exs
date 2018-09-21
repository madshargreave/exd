defmodule Exd.Plugin.StringTest do
  use Exd.PluginCase,
    plugin: Exd.Plugin.String

  describe "replace/3" do
    test "it replaces strings" do
      assert "hello there" == Exd.Plugin.apply({:replace, "hello.there", ".", " "})
    end
  end

  describe "interpolate/3" do
    test "it works when replacements are given as a string" do
      assert "hello mads" == Exd.Plugin.apply({:interpolate, "hello ?", "mads"})
    end

    test "it works when replacements are given as a list" do
      assert "hello mads" == Exd.Plugin.apply({:interpolate, "hello ?", ["mads"]})
    end

    test "it works when with multiple replacements" do
      assert "hello mads" == Exd.Plugin.apply({:interpolate, "? ?", ["hello", "mads"]})
    end
  end

  describe "regex/2" do
    test "it works when regex is a string" do
      assert "hello" == Exd.Plugin.apply({:regex, "hello.there", "^(hello)"})
    end

    test "it works when regex primitive" do
      assert "hello" == Exd.Plugin.apply({:regex, "hello.there", ~r/^(hello)/})
    end
  end

  describe "trim/1" do
    test "it trims string" do
      assert "hello" == Exd.Plugin.apply({:trim, " hello "})
    end
  end

  describe "downcase/1" do
    test "it downcases string" do
      assert "hello" == Exd.Plugin.apply({:downcase, "HELLO"})
    end
  end

  describe "upcase/1" do
    test "it upcases string" do
      assert "HELLO" == Exd.Plugin.apply({:upcase, "hello"})
    end
  end

  describe "capitalize/1" do
    test "it capitalizes string" do
      assert "Hello" == Exd.Plugin.apply({:capitalize, "hello"})
    end
  end

end
