defmodule Exd.Sink do
  @moduledoc """
  Defines a source

  ## Options

    * `:adapter` - The source adapter module and options
    * `:concurrency` - The number of concurrent source connections

  ## Usage

      defmodule PersonSource do
        use Exd.Source,
          adapter: {
            Exd.Sources.File,
              file_path: "test/support/fixtures/people.json"
          }
      end
  """
  use GenStage

  def start_link(opts) do
    GenStage.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    {adapter, adapter_opts} = Keyword.fetch!(opts, :adapter)
    {:ok, sink_state} = adapter.init(adapter_opts)
    producers = %{}
    {:producer_consumer, {adapter, sink_state, producers}}
  end

  @impl true
  def handle_events(events, _from, {adapter, sink_state, producers}) do
    {:ok, sink_state} = adapter.handle_into(events, sink_state)
    {:noreply, events, {adapter, sink_state, producers}}
  end

  @impl true
  def handle_cancel(_, from, {adapter, sink_state, producers}) do
    :timer.sleep(100)
    GenStage.async_info(self(), :terminate)
    {:noreply, [], {adapter, sink_state, Map.delete(producers, from)}}
  end

  @impl true
  def handle_info(:terminate, state) do
    {:stop, :shutdown, state}
  end

  # @impl true
  # def handle_subscribe(:producer, _options, from, {adapter, sink_state, producers} = state) do
  #   producers = Map.put(producers, from, true)
  #   {:manual, {adapter, sink_state, producers}}
  # end

end
