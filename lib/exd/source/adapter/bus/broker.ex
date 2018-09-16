defmodule Exd.Source.Bus.Broker do
  @moduledoc """
  Broker for event bus
  """
  use GenServer

  ## Client

  @doc """
  Starts broker

  ## Options

    * `topic` - Topic to consume events from
    * `parent` - PID of parent process
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def process({topic, id} = event_shadow) do
    GenServer.cast(__MODULE__, event_shadow)
  end

  ## Server

  @impl true
  def init(opts) do
    topic = Keyword.fetch!(opts, :topic)
    :ok = EventBus.register_topic(__MODULE__, topic)
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:record_received, id} = event_shadow, state) do
    record = EventBus.fetch_event(event_shadow)
    {:noreply, state}
  end

end
