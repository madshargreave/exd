defmodule Exd.Plugin.String do
  @moduledoc false

  @doc false
  defmacro __using__(_opts) do
    quote do
      use Exd.Plugin.Adapter
      alias Exd.Plugin.String.Helpers, as: StringHelpers

      @impl true
      def apply({:replace, value, pattern, replacement}) do
        StringHelpers.replace(value, pattern, replacement)
      end

      @impl true
      def apply({:interpolate, value, bindings}) do
        StringHelpers.interpolate(value, bindings)
      end

      @impl true
      def apply({:regex, value, regex}) do
        StringHelpers.regex(value, regex)
      end

      @impl true
      def apply({:trim, value}) do
        StringHelpers.trim(value)
      end

      @impl true
      def apply({:downcase, value}) do
        StringHelpers.downcase(value)
      end

      @impl true
      def apply({:upcase, value}) do
        StringHelpers.upcase(value)
      end

      @impl true
      def apply({:capitalize, value}) do
        StringHelpers.capitalize(value)
      end

      @impl true
      def apply({:cast, value, type}) do
        StringHelpers.cast(value, type)
      end

    end
  end
end
