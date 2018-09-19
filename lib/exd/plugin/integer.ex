defmodule Exd.Plugin.Integer do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Exd.Plugin.Adapter

      @impl true
      def apply({:add, left, right}) do
        left + right
      end

      @impl true
      def apply({:subtract, left, right}) do
        left - right
      end

      @impl true
      def apply({:multiply, left, right}) do
        left * right
      end

      @impl true
      def apply({:divide, left, right}) do
        left / right
      end

    end
  end

end
