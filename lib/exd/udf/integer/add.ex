defmodule Exd.UDF.Integer.Add do
  @moduledoc """
  Multiply two numbers
  """
  use Exd.UDF

  @impl true
  def name do
    :multiply
  end

  @impl true
  def eval([a, b]) do
    {:ok, a + b}
  end

end
