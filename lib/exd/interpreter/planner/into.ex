defmodule Exd.Interpreter.Into do
  @moduledoc """
  Select clause
  """

  @doc """
  Resolves select statement
  """
  @spec into(Flow.t(), function()) :: Flow.t()
  def into(flow, callback) when is_function(callback) do
    flow
    |> Flow.each(callback)
  end

end
