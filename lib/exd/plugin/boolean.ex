defmodule Exd.Plugin.Boolean do
  @moduledoc false

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Exd.Plugin.Helpers

      defhelper {:if, predicate, then_branch, else_branch} do
        if predicate, do: then_branch, else: else_branch
      end

    end
  end
end
