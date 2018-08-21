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
  use Exd.Adapter

  defstruct [
    list: nil,
    cursor: %{limit: 10}
  ]

  @type t :: %__MODULE__{}

  @doc """
  The list itself is the state of the source
  """
  @impl true
  def init(context, opts) do
    list = Keyword.fetch!(opts, :value)
    state = %__MODULE__{list: list}
    {:ok, state}
  end

  @doc """
  Paginates the last
  """
  @impl true
  def paginate(state) do
    case Enum.split(state.list, state.cursor.limit) do
      {[], _} ->
        :done
      {produced, remaining} ->
        # :timer.sleep(500)
        {:ok, produced, %__MODULE__{state | list: remaining}}
    end
  end

  @doc """
  Inserts documents into list
  """
  @impl true
  def insert(document, state) do
    new_state = %__MODULE__{state | list: [document | state.list]}
    {:ok, new_state}
  end

end
