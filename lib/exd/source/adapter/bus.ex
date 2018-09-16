defmodule Exd.Source.Bus do
  @moduledoc """
  A list based source

  ## Options

    * `:value` - The list itself
  """
  use Exd.Source.Adapter
  alias Exd.Source.Bus.Broker

  defstruct [
    topic: nil,
    broker: nil,
    shadows: []
  ]

  @impl true
  def init([{:topic, topic} | rest]) do
    {:ok, broker} = Broker.start_link(parent: self())
    {
      :ok,
      %__MODULE__{
        topic: topic,
        broker: broker
      }
    }
  end

  @impl true
  def handle_from(demand, state) do
    {shadows, buffered} = Enum.split(state.shadows, demand)
    produced =
      for shadow <- shadows do
        EventBus.fetch_event(shadow)
      end
    {:ok, %__MODULE__{state | shadows: buffered}}
  end

  @impl true
  def handle_info({:record_received, event_id} = shadow, _, state) do
    {:noreply, :ok, %__MODULE__{state | shadows: state.shadows ++ [shadow]}}
  end

end
