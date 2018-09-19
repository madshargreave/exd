defmodule Exd.Plugin.Adapter do
  @moduledoc false

  @doc """
  Applies function or source to input record
  """
  @callback apply(tuple()) :: [any()]

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour Exd.Plugin.Adapter
    end
  end

end
