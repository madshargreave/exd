defmodule Exd.Record do
  @moduledoc false
  defstruct key: nil,
            value: nil,
            flag: nil,
            source: nil,
            window: nil,
            group_by: [],
            timestamp: nil,
            meta: %{}

  @type key :: binary()
  @type value :: any()
  @type t :: %__MODULE__{key: key(), value: value()}

  def from(value) do
    %__MODULE__{
      value: value
    }
  end

  def from(key, value) when is_atom(key) do
    %__MODULE__{
      key: key,
      value: value
    }
  end

  def from(%__MODULE__{value: record_value} = record, value) when is_map(record_value) do
    new_value = Map.merge(record.value, value)
    %__MODULE__{record | value: new_value}
  end
  def from(record, value) do
    %__MODULE__{record | value: value}
  end

  @spec new(key(), value()) :: t()
  def new(key, value, opts \\ []) when is_binary(key) and not is_nil(value) do
    %__MODULE__{
      key: key,
      value: value,
      flag: nil,
      meta: (for {key, value} <- opts, into: %{}, do: {key, value})
    }
  end

  @spec put(t(), binary(), any()) :: t()
  def put(%__MODULE__{} = record, namespace, value) do
    value = Map.put(record.value, namespace, value)
    %{record | value: value}
  end

  @spec flag(t(), term()) :: t()
  def flag(%__MODULE__{} = record, flag) do
    %{record | flag: flag}
  end

  @spec flag(t(), term()) :: boolean()
  def flag?(%__MODULE__{} = record, flag) do
    record.flag == flag
  end

end
