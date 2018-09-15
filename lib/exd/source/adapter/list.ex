defmodule Exd.Source.List do
  @moduledoc """
  A list based source

  ## Options

    * `:value` - The list itself
  """
  use Exd.Source.Adapter

  defstruct [
    list: nil,
    key: nil,
    cursor: %{limit: 10}
  ]

  @impl true
  def init([{:value, list} | rest]) do
    {
      :ok,
      %__MODULE__{
        list: list,
        key: rest[:key] || "id"
      }
    }
  end

  @impl true
  def handle_from(demand, state) do
    case Enum.split(state.list, state.cursor.limit) do
      {[], _} ->
        :done
      {produced, remaining} ->
        {:ok, produced, %__MODULE__{state | list: remaining}}
    end
  end

  @impl true
  def handle_join(contexts, state) do
    keys = for context <- contexts, do: Keyword.fetch!(context, :key)
    matches = for item <- state.list, item[state.key] in keys, do: item
    {:ok, matches}
  end

end
