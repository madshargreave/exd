defmodule Exd.Plugin.IntervalTest do
  use Exd.QueryCase
  alias Exd.Repo

  describe "interval/1" do
    test "it emits events every interval" do
      parent = self()

      Repo.start_link(
        from i in [1, 2, 3],
        select: i,
        into: fn i -> send(parent, {:event, i.value}) end
      )

      assert_receive {:event, 1}
      assert_receive {:event, 2}
      assert_receive {:event, 3}
    end
  end
end
