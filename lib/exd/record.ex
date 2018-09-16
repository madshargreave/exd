defmodule Exd.Record do
  @moduledoc """
  An envelope for events as they traverse the stream
  """
  defstruct key: nil,
            value: nil,
            flag: nil,
            __meta__: %{}

  @type key :: binary()
  @type value :: any()
  @type t :: %__MODULE__{key: key(), value: value()}

  @doc """
  Create a new record
  """
  @spec new(key(), value()) :: t()
  def new(key, value) when is_binary(key) and not is_nil(value) do
    %__MODULE__{
      key: key,
      value: value,
      flag: nil
    }
  end

  @doc """
  Puts context
  """
  @spec put(t(), binary(), any()) :: t()
  def put(%__MODULE__{} = record, namespace, value) do
    value = Map.put(record.value, namespace, value)
    %{record | value: value}
  end

  @doc """
  Mark record as filtered
  """
  @spec flag(t(), term()) :: t()
  def flag(%__MODULE__{} = record, flag) do
    %{record | flag: flag}
  end

  @doc """
  Check if record has flag
  """
  @spec flag(t(), term()) :: boolean()
  def flag?(%__MODULE__{} = record, flag) do
    record.flag == flag
  end

end
