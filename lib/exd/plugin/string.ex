defmodule Exd.Plugin.String do
  @moduledoc """
  String helpers
  """

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Exd.Plugin.Helpers
      alias Exd.Plugin.String.Helpers, as: StringHelpers

      defhelper {:replace, value, pattern, replacement} do
        StringHelpers.replace(value, pattern, replacement)
      end

      defhelper {:regex, value, regex} do
        StringHelpers.regex(value, regex)
      end

      defhelper {:trim, value} do
        StringHelpers.trim(value)
      end

      defhelper {:downcase, value} do
        StringHelpers.downcase(value)
      end

      defhelper {:cast, value, type} do
        StringHelpers.cast(value, type)
      end

    end
  end
end
