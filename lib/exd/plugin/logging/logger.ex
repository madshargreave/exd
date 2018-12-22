defmodule Exd.Plugin.Logger do
  @moduledoc """
  Logs events to stdout
  """
  require Logger
  use Exd.Plugin

  @impl true
  def name do
    :logger
  end

  @impl true
  def init(_) do
    state = %{}
    {:sink, state}
  end

  @impl true
  def handle_process(records, state) do
    for record <- records do
      Logger.info "Received record: #{record.key}"
    end
    {:ok, [], state}
  end

end
