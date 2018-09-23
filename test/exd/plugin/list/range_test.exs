defmodule Exd.Plugin.List.RangeTest do
  use Exd.QueryCase
  alias Exd.Repo

  describe "range/3" do
    test "it generates a range" do
      assert [
        [0, 1, 2]
      ] ==
        Repo.all(
          from range in {:range, 0, 2},
          select: range
        )
    end
  end

end
