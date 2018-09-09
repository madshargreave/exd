defmodule Exd.Sink.Adapter do
  @moduledoc """
  Adapter for source implementations
  """

  @typedoc "State of source"
  @type state :: map

  @typedoc "State of source"
  @type demand :: integer

  @typedoc "State of source"
  @type config :: keyword

  @typedoc "State of source"
  @type context :: [map]

  @typedoc "State of source"
  @type documents :: [map]

  @doc """
  Initializes the state of the source
  """
  @callback init(config) :: {:ok, state}

  @doc """
  Initializes the state of the source
  """
  @callback handle_into(documents, state) :: {:ok, state} | :error

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour Exd.Sink.Adapter
    end
  end

end
