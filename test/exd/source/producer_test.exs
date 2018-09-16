defmodule Exd.Source.ProducerTest do
  use ExUnit.Case

  alias Exd.{Repo, Query}
  alias Exd.Sink.Test, as: TestSink

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

  describe "from/1" do
    setup do
      {:ok, producer} = DummyProducer.start_link()
      {:ok, producer: producer}
    end

    test "it returns preconfigured value", context do
      query =
        Query.new
        |> Query.from("jobs", context.producer)
        |> Query.select("jobs")
        |> Query.into(
          "test",
          {
            TestSink,
              parent_pid: self()
          }
        )
        |> Repo.start_link

      DummyProducer.notify(context.producer, %{"title" => "job 1" })
      DummyProducer.notify(context.producer, %{"title" => "job 2"})
      assert_receive {:results, [%{"title" => "job 1" }]}
      assert_receive {:results, [%{"title" => "job 2" }]}
    end
  end
end
