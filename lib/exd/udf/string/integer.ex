defmodule Exd.UDF.String.Integer do
  @moduledoc """
  Multiply two numbers
  """
  use Exd.UDF

  @impl true
  def name do
    :integer
  end

  @impl true
  def eval([nil]), do: {:ok, nil}
  def eval([string]) do
    case Integer.parse(string) do
      {integer, ""} ->
        {:ok, integer}
      _ ->
        :error
    end
  end

end
