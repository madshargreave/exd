defmodule Exd.Plugin.List.ArrayAgg do
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
  def handle_parse({:array_agg, element}) do
    {:ok, element}
  end

  @impl true
  def handle_calls(elements) do
    {:ok, [elements]}
  end

end
