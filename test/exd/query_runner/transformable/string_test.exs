defmodule Exd.Transformable.StringTest do
  use ExUnit.Case
  alias Exd.Transformable

  describe "replace" do
    test "it replaces pattern with replacement" do
      assert "hello there" == Transformable.transform("hello.there", {:replace, ".", " "})
    end
  end

  describe "regex" do
    test "it captures and returns group" do
      assert "hello" == Transformable.transform("123 hello 456", {:regex, "([a-z]+)"})
    end
  end

  describe "trim" do
    test "it trims whitespace" do
      assert "hello" == Transformable.transform("\nhello \n", :trim)
    end
  end

  describe "downcase" do
    test "it downcases string" do
      assert "hello" == Transformable.transform("HELLO", :downcase)
    end
  end

  describe "cast" do
    test "it cast floats" do
      assert 1.1 == Transformable.transform("1.1", {:cast, :float})
    end

    test "it cast integers" do
      assert 10 == Transformable.transform("10", {:cast, :integer})
    end
  end

end
