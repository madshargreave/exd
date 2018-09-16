defmodule Exd.Transport.Test do
  @moduledoc """
  Transport that sends messages to a parent test process
  """
  use Exd.Transport

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
  def send(documents, state) do
    Process.send(state.parent_pid, :message, documents)
    {:ok, state}
  end

end
