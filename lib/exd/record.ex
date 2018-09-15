defmodule Exd.Record do
  @moduledoc """
  An envelope for events as they traverse the stream
  """
  defstruct key: nil,
            value: nil

  @type key :: binary()
  @type value :: any()
  @type t :: %__MODULE__{key: key(), value: value()}

  @doc """
  Create a new record
  """
  @spec new(key(), value()) :: t()
  def new(key, value) when is_binary(key) and not is_nil(value) do
    %__MODULE__{key: key, value: value}
  end

  @doc """
  Puts context
  """
  @spec put(t(), binary(), any()) :: t()
  def put(%__MODULE__{} = record, namespace, value) do
    value = Map.put(record.value, namespace, value)
    %{record | value: value}
  end

end
