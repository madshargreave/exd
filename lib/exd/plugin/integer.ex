defmodule Exd.Plugin.Integer do
  @moduledoc false

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Exd.Plugin.Helpers

      defhelper {:add, left, right} do
        left + right
      end

      defhelper {:subtract, left, right} do
        left - right
      end

      defhelper {:multiply, left, right} do
        left * right
      end

    end
  end

end
