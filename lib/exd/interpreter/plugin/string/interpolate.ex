defmodule Exd.Plugin.String.Interpolate do
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
  def handle_parse({:interpolate, [string, binding]}) when is_binary(binding), do: handle_parse({:interpolate, [string, [binding]]})
  def handle_parse({:interpolate, [string, bindings]}) do
    {:ok, {string, bindings}}
  end

  @impl true
  def handle_eval(calls) do
    produced =
      for {string, bindings} <- calls do
        bindings
        |> Enum.reduce(string, fn replacement, acc ->
          acc
          |> String.replace("?", replacement, global: false)
        end)
      end
    {:ok, produced}
  end

end

