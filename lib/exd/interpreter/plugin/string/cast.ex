defmodule Exd.Plugin.String.Cast do
  @moduledoc """
  Generates a stream of numbers between `min` and `max` bounds

  ## Example

      [
        %{number: 0},
        %{number: 1},
        %{number: 2}
      ] =
        Query.new
        |> Query.from("range", {:range, 0, 2})
        |> Query.select(%{
          number: {:unnest, "range"}
        })
        |> Query.to_list
  """
  use Exd.Plugin

  @impl true
  def handle_parse({:cast, string, type}) do
    {:ok, {string, type}}
  end

  @impl true
  def handle_eval(calls) do
    produced =
      for {string, type} <- calls do
        case type do
          :float -> String.to_float(string)
          :integer ->
            string
            |> String.replace(",", "")
            |> String.to_integer
        end
      end
    {:ok, produced}
  end

end
