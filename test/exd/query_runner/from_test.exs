defmodule Exd.Runner.FromTest do
  use ExUnit.Case

  alias Exd.{Repo, Query, Record}
  alias Exd.Runner.Planner
  alias Exd.Runner.From
  alias Exd.Source.List, as: ListSource

  describe "from/2" do
    test "it works with lists" do
      assert [
        %{"name" => "bitcoin"},
        %{"name" => "ethereum"},
        %{"name" => "ripple"}
      ] =
        Query.new
        |> Query.from(
          "coins",
          [
            %{"name" => "bitcoin"},
            %{"name" => "ethereum"},
            %{"name" => "ripple"}
          ],
          max_demand: 1,
          key: fn event -> Kernel.get_in(event, ["coins", "name"]) end
        )
        |> Query.select("coins")
        |> Planner.plan()
        |> Enum.sort
    end

    test "it works with subqueries" do
      subquery =
        Query.new
        |> Query.from(
          "inner",
          [
            %{"name" => "bitcoin"},
            %{"name" => "ethereum"},
            %{"name" => "ripple"}
          ]
        )
        |> Query.select("inner")

      assert [
        %{"name" => "bitcoin"},
        %{"name" => "ethereum"},
        %{"name" => "ripple"}
      ] =
        Query.new
        |> Query.from("coins", subquery)
        |> Query.select("coins")
        |> Planner.plan()
        |> Enum.sort
    end

    defmodule DummyProducer do
      use GenStage

      def start_link do
        GenStage.start_link(__MODULE__, :ok)
      end

      def notify(pid, message) do
        GenStage.cast(pid, {:notify, message})
      end

      @impl true
      def init(_) do
        buffer = []
        {:producer, buffer}
      end

      @impl true
      def handle_demand(demand, state) do
        {:noreply, [], state}
      end

      @impl true
      def handle_cast({:notify, message}, state) do
        {:noreply, [message], state}
      end

    end

    test "it works with PIDs" do
      {:ok, producer} = DummyProducer.start_link()

      assert {:ok, pid} =
        Query.new
        |> Query.from("jobs", producer)
        |> Query.select("jobs")
        |> Repo.start_link
    end
  end
end
