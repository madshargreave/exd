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
  use GenStage

  defstruct [:min, :max, :done?]

  # Client

  def start_link(opts \\ []) do
    GenStage.start_link(__MODULE__, opts)
  end

  @impl true
  def handle_parse({:range, [min, max]}) do
    opts = [min: min, max: max]
    spec = {__MODULE__, opts}
    {:ok, spec}
  end

  @impl true
  def handle_eval(calls) do
    produced = for {min, max} <- calls, do: [Enum.to_list(min..max)]
    {:ok, produced}
  end

  # Server

  @impl true
  def init(opts) do
    min = Keyword.fetch!(opts, :min)
    max = Keyword.fetch!(opts, :max)
    state =
      %__MODULE__{
        min: min,
        max: max,
        done?: false
      }
    {:producer, state}
  end

  @impl true
  def handle_demand(incoming_demand, %{done?: false} = state) do
    events = [Enum.to_list(state.min..state.max)]
    Process.send_after(self, :done, 0)
    {:noreply, events, %{state | done?: true}}
  end

  def handle_info(:done, state) do
    {:stop, :normal, state}
  end

end
