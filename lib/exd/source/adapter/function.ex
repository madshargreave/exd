defmodule Exd.Source.Function do
  @moduledoc """
  A list based source

  ## Options

    * `:value` - The list itself
  """
  use Exd.Source.Adapter

  defstruct [
    fn: nil
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

  # @impl true
  def handle_join(records, state) do
    results = state.fn.(records)
    {:ok, results}
  end

end
