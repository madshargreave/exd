defmodule Exd.Source.Bus do
  @moduledoc """
  A list based source

  ## Options

    * `:value` - The list itself
  """
  use Exd.Source.Adapter

  defstruct [
    topic: nil
  ]

  # @impl true
  # def init([{:value, list} | rest]) do
  #   {
  #     :ok,
  #     %__MODULE__{
  #     }
  #   }
  # end

  # @impl true
  # def handle_from(_demand, state) do
  #   case Enum.split(state.list, state.cursor.limit) do
  #     {[], _} ->
  #       :done
  #     {produced, remaining} ->
  #       {:ok, produced, %__MODULE__{state | list: remaining}}
  #   end
  # end

  # @impl true
  # def handle_join(contexts, state) do
  #   keys = for context <- contexts, do: Keyword.fetch!(context, :key)
  #   matches = for item <- state.list, item[state.key] in keys, do: item
  #   {:ok, matches}
  # end

end
