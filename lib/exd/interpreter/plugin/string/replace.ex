defmodule Exd.Plugin.String.Replace do
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
  def handle_parse({:replace, [value, pattern, replacement]}) do
    {:ok, {value, pattern, replacement}}
  end

  @impl true
  def handle_eval(calls) do
    produced =
      for {value, pattern, replacement} <- calls do
        String.replace(value, pattern, replacement)
      end
    {:ok, produced}
  end

end
