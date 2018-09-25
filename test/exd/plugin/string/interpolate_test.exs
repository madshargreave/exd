defmodule Exd.Plugin.String.InterpolateTest do
  use Exd.QueryCase
  alias Exd.Repo

  describe "interpolate/3" do
    test "it works when replacements are given as a string" do
      assert "hello mads" ==
        Repo.first(
          from p in [%{"name" => "mads"}],
          select: interpolate("hello ?", p.name)
        )
    end

    test "it works when replacements are given as a list" do
      assert "hello mads" ==
        Repo.first(
          from p in [%{"name" => "mads"}],
          select: interpolate("hello ?", [p.name])
        )
    end

    test "it works when with multiple replacements" do
      assert "mads hargreave" ==
        Repo.first(
          from p in [%{"first_name" => "mads", "last_name" => "hargreave"}],
          select: interpolate("? ?", [p.first_name, p.last_name])
        )
    end
  end

end
