defmodule Exd.Plugin.List.Range do
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
  def handle_parse({:range, min, max}) do
    {:ok, {min, max}}
  end

  @impl true
  def handle_eval(calls) do
    produced = for {min, max} <- calls, do: [Enum.to_list(min..max)]
    {:ok, produced}
  end
end
