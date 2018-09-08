defmodule Exd.Source do
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
  require Logger
  use GenStage

  def start_link(opts) do
    GenStage.start_link(__MODULE__, opts)
  end

  def insert(documents) do
    GenServer.call(__MODULE__, {:insert, documents})
  end

  def get_state(source) do
    GenServer.call(source, :get_state)
  end

  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  @impl true
  def init(opts) do
    {adapter, adapter_opts} = Keyword.fetch!(opts, :adapter)
    {:ok, source_state} = adapter.init(adapter_opts)
    {:producer, {adapter, 0, [], source_state}}
  end

  @impl true
  def handle_demand(demand, {
    adapter,
    buffered_demand,
    buffered_events,
    source_state
  }) do
    dispatch_events({
      adapter,
      demand + buffered_demand,
      buffered_events,
      source_state
    })
  end

  @impl true
  def handle_call({:insert, documents}, _from, {
    adapter,
    buffered_demand,
    buffered_events,
    source_state
  }) do
    case adapter.insert(documents, source_state) do
      {:ok, source_state} ->
        dispatch_events({
          adapter,
          buffered_demand,
          buffered_events,
          source_state
        })
    end
  end

  @impl true
  def handle_call(:get_state, _from, {_demand, _events, source_state} = state) do
    {:reply, source_state, [], state}
  end

  @doc """

  """
  defp dispatch_events({
    adapter,
    demand,
    buffered_events,
    source_state
  } = state)
    when length(buffered_events) < demand
  do
    case adapter.handle_from(demand, source_state) do
      {:ok, produced, new_source_date} ->
        dispatch_events({adapter, demand, buffered_events ++ produced, new_source_date})
      :done ->
        {:stop, :normal, state}
    end
  end

  @doc """

  """
  defp dispatch_events({
    adapter,
    demand,
    events,
    source_state
  } = _state)
    when length(events) >= demand
  do
    {events_to_dispatch, remaining_events} = Enum.split(events, demand)
    {:noreply, events_to_dispatch, {adapter, 0, remaining_events, source_state}}
  end

end
