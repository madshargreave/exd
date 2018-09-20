defmodule Exd.Source.Function do
  @moduledoc """
  A list based source

  ## Options

    * `:value` - The list itself
  """
  use Exd.Source.Adapter

  defstruct [
    fn: nil,
    done: false
  ]

  @impl true
  def init([{:fn, function} | _rest]) do
    {
      :ok,
      %__MODULE__{
        fn: function
      }
    }
  end

  def handle_from(demand, %{done: true} = _state), do: :done
  def handle_from(demand, %{done: false, fn: func} = state) do
    produced = func.(%{})
    {:ok, produced, %__MODULE__{state | done: true}}
  end

  # @impl true
  def handle_join(records, state) do
    results = state.fn.(records)
    {:ok, results}
  end

end
