defmodule Exd.Source.Adapter do
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
  @callback handle_from(demand, state) :: {:ok, documents, state} | :done

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour Exd.Source.Adapter
    end
  end

end
