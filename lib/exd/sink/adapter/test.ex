defmodule Exd.Sink.Test do
  @moduledoc """
  A sink that sends message to parent process
  """
  use Exd.Sink.Adapter, name: :test

  defstruct parent_pid: nil

  @impl true
  def init(opts) do
    parent_pid = Keyword.fetch!(opts, :parent_pid)
    {
      :ok,
      %__MODULE__{
        parent_pid: parent_pid
      }
    }
  end

  @impl true
  def handle_into(documents, state) do
    send state.parent_pid, {:results, documents}
    {:ok, state}
  end

end
