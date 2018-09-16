defmodule Exd.Plugin.String do
  @moduledoc """

  """

  defmacro __using__(_opts) do
    quote do
      import Exd.Plugin.Helpers
      alias Exd.Plugin.String.Helpers

      defhelper {:replace, value, pattern, replacement} do
        Helpers.replace(value, pattern, replacement)
      end

      defhelper {:regex, value, regex} do
        Helpers.regex(value, regex)
      end

    end
  end

end
