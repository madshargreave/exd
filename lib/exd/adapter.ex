defmodule Exd.Adapter do
  @moduledoc """
  Defines a module that canbe queried as a source
  """

  @doc """
  Returns initial source state
  """
  @callback init(map(), keyword()) :: {:ok, map()} | {:error, term()} | :error

  @doc """
  Returns a new batch of documents from source and sends them downstream
  """
  @callback paginate(map) :: {:ok, [map()], map()} | :done | {:error, term()} | :error

  @doc """
  Inserts batch into source
  """
  @callback insert(map(), map()) :: {:ok, map()} | {:error, term()} | :error

  @optional_callbacks  insert: 2

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour Exd.Adapter
    end
  end
end
