defmodule Exd.Runner.Commit do
  @moduledoc """
  Select clause
  """
  require Logger

  @doc """
  Resolves select statement
  """
  @spec commit(Flow.t) :: Flow.t
  def commit(flow) do
    flow
    |> Flow.each(fn record ->
      Logger.info "Commit record with key: #{record.key}"
    end)
  end

end