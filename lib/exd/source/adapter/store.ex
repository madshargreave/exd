defmodule Exd.Source.Store do
  @moduledoc """
  Use a store as source
  """
  use Exd.Source.Adapter

  defstruct store_pid: nil,
            adapter: nil,
            done: false

  @impl true
  def init(opts) do
    {adapter, adapter_opts} = Keyword.fetch!(opts, :adapter)
    {:ok, store_pid} = adapter.start_link(adapter_opts)

    {
      :ok,
      %__MODULE__{
        adapter: adapter,
        store_pid: store_pid
      }
    }
  end

  @impl true
  def handle_from(demand, %{done: true} = _state), do: :done
  def handle_from(demand, state) do
    {:ok, matches} = state.adapter.all(:my_store)
    {:ok, matches, %__MODULE__{state | done: true}}
  end

end
