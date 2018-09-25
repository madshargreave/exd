defmodule Exd.Plugin.String.Downcase do
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
  def handle_parse({:downcase, string}) do
    {:ok, string}
  end

  @impl true
  def handle_eval(calls) do
    produced =
      for string <- calls do
        String.downcase(string)
      end
    {:ok, produced}
  end

end
