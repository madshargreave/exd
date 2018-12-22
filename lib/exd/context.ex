defmodule Exd.Context do
  @moduledoc """
  Contains contextual information related to query and its execution

  The context will be passed to all plugins in the `init/1` callback

    defmodule Exd.Plugin.MyPlugin do
      use Exd.Plugin

      def init(%Exd.Context{} = context) do
        ...
        {:ok, state}
      end

    end
  """
  defstruct [
    env: nil,
    meta: nil,
    arguments: nil
  ]
end
