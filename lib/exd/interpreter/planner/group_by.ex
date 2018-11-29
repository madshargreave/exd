defmodule Exd.Interpreter.GroupBy do
  @moduledoc """
  Select clause
  """

  @doc """
  Resolves select statement
  """
  @spec group_by(Flow.t(), function()) :: Flow.t()
  def group_by(flow, keys) when is_list(keys) do
    flow
    |> Flow.map(fn record ->
      record
    end)
  end

end
