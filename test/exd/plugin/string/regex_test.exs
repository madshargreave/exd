defmodule Exd.Plugin.String.RegexTest do
  use Exd.QueryCase
  alias Exd.Repo

  describe "regex/2" do
    test "it works when regex is a string" do
      assert "hello" ==
        Repo.first(
          from g in ["hello.there"],
          select: regex(g, "'^(hello)'")
        )
    end

    test "it works when regex primitive" do
      assert "hello" ==
        Repo.first(
          from g in ["hello.there"],
          select: regex(g, ~r/^(hello)/)
        )
    end
  end
end
