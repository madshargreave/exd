defmodule Exd.Store.Adapter.ETS do
  @moduledoc """
  Adapter module for ETS-based state stores

  ## Options

    * `table_name` - Name of ETS table
    * `ttl` - Time to live before automatically evicted closed windows
  """
  use Exd.Store.Adapter

  @table :state_store

  @impl true
  def init(_opts) do
    table = :ets.new(@table, [:set, :public, :named_table])
    {:ok, :no_state}
  end

  @impl true
  def get(key) do
    case :ets.lookup(@table, key) do
      [{key, data}] ->
        {:ok, data}
      _ ->
        {:error, :not_found}
    end
  end

  @impl true
  def put(key, value) do
    true = :ets.insert(@table, {key, value})
    :ok
  end

end
