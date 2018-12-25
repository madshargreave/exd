defmodule Exd.Plugin.List.Range do
  @moduledoc """
  Multiply two numbers
  """
  use Exd.Plugin
  alias Exd.{Context, Record}

  @impl true
  def name do
    :range
  end

  @impl true
  def init(%Context{params: [min, max]} = context) do
    state = %{min: min, max: max}
    {:producer, state}
  end

  @impl true
  def handle_demand(demand, %{min: min, max: max} = state) when min < max do
    max = Enum.min([max, demand])
    produced =
      state.min..max
      |> Enum.to_list
      |> Enum.map(&Record.from(&1))

    new_state = %{state | min: min + length(produced)}
    if new_state.min >= new_state.max, do: GenStage.async_info(self(), :terminate)
    {:noreply, produced, new_state}
  end
  def handle_demand(_demand, state),
    do: {:stop, :normal, state}

end
