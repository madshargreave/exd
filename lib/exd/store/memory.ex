defmodule Exd.Store.Memory do
  @moduledoc """
  Uses an in-memory ETS table as store
  """
  use Exd.Store
  use GenServer

  @typedoc "Runtime options for in-memory store"
  @type options :: [{:name, term() | binary()}]

  ## Client

  @spec start_link(options()) :: GenServer.on_start()
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts)
  end

  @impl true
  def all(name) do
    entries = for {key, value} <- :ets.match_object(name, {:"$1", :"_"}), do: value
    {:ok, entries}
  end

  @impl true
  def get(name, key) do
    case :ets.lookup(name, key) do
      [{key, value}] ->
        {:ok, value}
      [] ->
        :not_found
      _ ->
        :error
    end
  end

  @impl true
  def put(name, key, value) do
    record = {key, value}
    case :ets.insert(name, record) do
      true ->
        :ok
      _ ->
        :error
    end
  end

  ## Server

  @impl true
  def init(opts) do
    setup_table(opts)
    {:ok, %{}}
  end

  ## Helpers

  defp setup_table(opts) do
    table_name = Keyword.fetch!(opts, :name)
    table_opts = [:set, :named_table, :public, read_concurrency: true]
    :ets.new(table_name, table_opts)

    initial_state = Keyword.get(opts, :initial_state)
    if initial_state do
      for doc <- initial_state do
        put(table_name, doc[opts[:primary_key]], doc)
      end
    end
  end

end
