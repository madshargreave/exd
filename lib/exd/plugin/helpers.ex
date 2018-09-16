defmodule Exd.Plugin.Helpers do
  @moduledoc false

  @doc """
  Register an SQL helper to be used in Exd queries
  """
  defmacro defhelper(invocation, do: block) do
    quote do
      def __helper__(unquote(invocation)) do
        unquote(block)
      end
    end
  end

end
