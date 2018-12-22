defmodule Exd.Store do
  @moduledoc """
  State store for joins and aggregations
  """
  alias Exd.Store.Adapter.ETS, as: DefaultStore

  @store Application.get_env(:exd, :store_adapter) || DefaultStore

  defdelegate init(keyword), to: @store
  defdelegate get(key), to: @store
  defdelegate put(key, value), to: @store
  defdelegate delete(key), to: @store

end
