defmodule Exd.Store do
  @moduledoc """
  A store acts as a materialized key-value view over a particular query's data
  """

  @type store_name :: binary() | term()
  @type key :: binary()
  @type value :: map()
  @type entry :: map()

  @doc """
  Returns data entries currently saved in store
  """
  @callback all(store_name()) :: {:ok, [value]} | :error

  @doc """
  Returns entry with given key
  """
  @callback get(store_name(), key()) :: {:ok, value()} | {:error, term()} | :not_found | :error

  @doc """
  Upserts entry as value with the given identifier as key
  """
  @callback put(store_name(), key(), value()) :: :ok | {:error, term}

  @doc """
  Sets a specific value of entry with identifier
  """
  @callback set(store_name(), key(), binary(), any()) :: :ok | {:error, term}

  @optional_callbacks set: 4

  @moduledoc false
  defmacro __using__(_opts) do
    quote do
      @behaviour Exd.Store
    end
  end

end
