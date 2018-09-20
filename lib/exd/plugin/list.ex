defmodule Exd.Plugin.List do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Exd.Plugin.Adapter

      def apply({:range, min, max}) do
        [
          Enum.to_list(min..max)
        ]
      end

    end
  end

end
