defmodule Exd.UDF.String.Regex do
  @moduledoc """
  Multiply two numbers
  """
  use Exd.UDF

  @impl true
  def name do
    :regex
  end

  @impl true
  def eval([string, regex]) do
    with {:ok, regex} <- Regex.compile(regex),
         [_match | captures] <- Regex.run(regex, string) do
      {:ok, List.last(captures)}
    else
      nil ->
        {:ok, nil}
      _ ->
        :error
    end
  end

end
