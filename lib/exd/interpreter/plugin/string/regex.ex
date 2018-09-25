defmodule Exd.Plugin.String.Regex do
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
  def handle_parse({:regex, [string, %Regex{} = regex]}), do: {:ok, {string, regex}}
  def handle_parse({:regex, [string, regex]}) when is_binary(regex) do
    {:ok, regex} = Regex.compile(regex)
    {:ok, {string, regex}}
  end

  @impl true
  def handle_eval(calls) do
    produced =
      for {string, regex} <- calls do
        case Regex.run(regex, string, global: true, capture: :all_but_first) do
          [group] -> group
          _ -> nil
        end
      end
    {:ok, produced}
  end

end
