defmodule Exd.Source.List do
  @moduledoc """
  A list based source

  ## Options

    * `:value` - The list itself

  ## Usage

      defmodule MyFile do
        use Exd.Source,
          adapter: {
            Exd.Source.List,
              value: [
                %{"name" => "mads"},
                %{"name" => "jack"}
              ]
          }
      end
  """
  use Exd.Source.Adapter

  defstruct [
    list: nil,
    cursor: %{limit: 10}
  ]

  @doc """
  The list itself is the state of the source
  """
  @impl true
  def init([{:value, list} | _rest]) do
    {
      :ok,
      %__MODULE__{
        list: list
      }
    }
  end

  @doc """
  handle_paginates the last
  """
  @impl true
  def handle_from(demand, state) do
    case Enum.split(state.list, state.cursor.limit) do
      {[], _} ->
        :done
      {produced, remaining} ->
        {:ok, produced, %__MODULE__{state | list: remaining}}
    end
  end

end
