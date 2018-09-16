defmodule Exd.Transport.Adapter do
  @moduledoc """
  Transport behaviour
  """

  @doc """
  Send documents to transport layer
  """
  @callback init(keyword()) :: {:ok, any()}

  @doc """
  Send documents to transport layer
  """
  @callback send(map()) :: {:ok, any()} | {:error, term()}

  @doc false
  defmacro __using__(__opts) do
    quote do
      @behaviour Exd.Transport
    end
  end

end
