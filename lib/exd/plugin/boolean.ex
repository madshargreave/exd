defmodule Exd.Plugin.Boolean do
  @moduledoc false

  @doc false
  defmacro __using__(_opts) do
    quote do
      use Exd.Plugin.Adapter

      @impl true
      def apply({:if, predicate, then_branch, else_branch}) do
        if predicate, do: then_branch, else: else_branch
      end

    end
  end
end
