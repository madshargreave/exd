defmodule Exd.Transport do
  @moduledoc """
  Transport behaviour
  """

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
