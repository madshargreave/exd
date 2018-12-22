defmodule Exd.Store.Adapter do
  @moduledoc """
  Behaviour for windowing stores
  """

  @typep key :: binary
  @typep value :: any

  @doc """
  Get the value corresponding to this key.
  """
  @callback init(keyword) :: {:ok, map}

  @doc """
  Get the value corresponding to this key.
  """
  @callback get(key) :: {:ok, value}

  @doc """
  Update the value associated with this key
  """
  @callback put(key, value) :: :ok | {:error, term}

  @doc """
  Delete the value from the store if one is present
  """
  @callback delete(key) :: :ok | {:error, term}

  defmacro __using__(_opts) do
    quote do
      @behaviour ExdStreams.Store.BaseStore
      @behaviour ExdStreams.Store.KeyValueStore
    end
  end

end
