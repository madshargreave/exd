defmodule Exd.Plugin.Env do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Exd.Plugin.Adapter

      @impl true
      def apply({:arg, value}), do: value

    end
  end

end
