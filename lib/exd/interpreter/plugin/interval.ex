defmodule Exd.Plugin.Interval do
  @moduledoc """
  A source plugin that emits a value every interval

  ## Example

      iex> Repo.all(
        from i in periodic(1000),
        select: i
      )
      [
        ~N[2018-10-10 10:00:00],
        ~N[2018-10-10 10:00:01],
        ~N[2018-10-10 10:00:02]
      ]
  """
  use Exd.Plugin
  use GenStage

  alias Exd.Record

  defstruct timeout: nil,
            pending_demand: 0,
            buffer: nil,
            seq: 0

  # Client

  def start_link(opts \\ []) do
    GenStage.start_link(__MODULE__, opts)
  end

  @impl true
  def handle_parse({:interval, [interval]}) do
    opts = [timeout: interval]
    {:ok, {__MODULE__, opts}}
  end

  # Server

  @impl true
  def init(opts) do
    timeout = Keyword.fetch!(opts, :timeout)
    state =
      %__MODULE__{
        timeout: timeout,
        buffer: :queue.new
      }
    Process.send_after(self(), :emit, 0)
    {:producer, state}
  end

  @impl true
  def handle_demand(incoming_demand, state) do
    dispatch_events(state, incoming_demand + state.pending_demand, [])
  end

  @impl true
  def handle_info(:emit, state) do
    Process.send_after(self(), :emit, state.timeout)
    timestamp = NaiveDateTime.utc_now
    key = Integer.to_string(state.seq)
    meta = %{}
    event = %Record{
      key: key,
      value: timestamp,
      source: self(),
      meta: meta
    }
    {:noreply, [event], %{state | seq: state.seq + 1}}
  end

  @impl true
  def handle_info({:commit, key, meta}, state) do
    {:noreply, [], state}
  end

  @impl true
  def terminate(reason, state) do
    :ok
  end

  defp dispatch_events(state, demand, events) do
    with d when d > 0 <- demand,
         {{:value, {from, event}}, queue} <- :queue.out(state.buffer) do
      GenStage.reply(from, :ok)
      dispatch_events(%{state | buffer: queue, pending_demand: demand - 1}, demand - 1, [event | events])
    else
      _ ->
        {:noreply, Enum.reverse(events), %{state | buffer: state.buffer, pending_demand: demand}}
    end
  end

end
