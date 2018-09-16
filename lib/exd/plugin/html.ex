defmodule Exd.Plugin.HTML do
  @moduledoc """

  """
  defmacro __using__(_opts) do
    quote do
      alias Exd.Plugin.HTML.Helpers

      def __function__(:parse_text, Helpers.parse_text/1)
      def __function__(:parse_href, Helpers.parse_href/1)
      def __function__(:parse_src, Helpers.parse_src/1)
      def __function__(:parse_alt, Helpers.parse_alt/1)
    end
  end
end
