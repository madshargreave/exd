defmodule Exd.Plugin.List do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Exd.Plugin.Adapter

      @impl true
      def apply({:unnest, list}) when is_list(list) do
        list
      end

    end
  end

end
