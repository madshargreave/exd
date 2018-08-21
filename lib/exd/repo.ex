
defmodule Exd.Repo do
  @moduledoc """
  Repository for sources
  """
  alias Exd.QueryRunner

  defmacro __using__(_opts) do
    quote do
      use GenServer

      # Client

      def start_link(opts \\ []) do
        GenServer.start_link(__MODULE__, opts, name: __MODULE__)
      end

      def stream(query) do
        GenServer.call(__MODULE__, {:stream, query})
      end

      # Server

      @impl true
      def init(_) do
        {:ok, nil}
      end

      @impl true
      def handle_call({:stream, query}, _from, state) do
        {:ok, __coordinator} =
          query
          |> QueryRunner.stream
          |> Flow.start_link
        {:reply, :ok, state}
      end

    end
  end

  @doc """
  Returns a stream of sourced records
  """
  def stream(query, opts \\ []) do
    QueryRunner.stream(query)
  end

end
