defmodule Exd.GenStageTest do
  use ExUnit.Case

  defmodule A do
    use GenStage

    def start_link(number) do
      GenStage.start_link(A, number)
    end

    def init(counter) do
      {:producer, counter}
    end

    def handle_demand(demand, counter) when demand > 0 do
      events = Enum.to_list(counter..counter+demand-1)
      Process.send_after self(), :exit, 1000 # Simulate that the producer is done producing work
      {:noreply, events, counter + demand}
    end

    def handle_info(:exit, state) do
      {:stop, :normal, state}
    end
  end

  defmodule B do
    use GenStage

    def start_link(number) do
      GenStage.start_link(B, number)
    end

    def init(number) do
      {:producer_consumer, number}
    end

    def handle_events(events, _from, number) do
      {:noreply, events, number} # Just forward events
    end
  end

  defmodule C do
    use GenStage

    def start_link(opts \\ []) do
      GenStage.start_link(C, :ok)
    end

    def init(:ok) do
      {:consumer, :the_state_does_not_matter}
    end

    def handle_events(events, _from, state) do
      # Wait for a second.
      Process.sleep(1000)

      # Inspect the events.
      IO.inspect(events)

      # We are a consumer, so we would never emit items.
      {:noreply, [], state}
    end
  end

  describe "schema/2" do
    test "it defines module as a struct" do
      producers = [{A, 0}]
      producer_consumers = [{{B, 2}, []}]

      numbers =
        producers
        |> Flow.from_specs
        # |> Flow.through_specs(producer_consumers) # Hangs here
        |> Enum.to_list

      # assert false
    end
  end
end
