defmodule Exd.Sink.Logger do
  @moduledoc """
  A sink that logs documents to stdout

  """
  use Exd.Sink.Adapter, name: :logger
  require Logger

  @impl true
  def init(opts) do
    {:ok, :no_state}
  end

  @impl true
  def handle_into(documents, state) do
    Logger.info "Received documents: #{inspect documents}"
    {:ok, state}
  end

end
