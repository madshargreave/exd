defmodule Exd.Plugin.Source do
  @moduledoc false

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Exd.Plugin.Helpers

      defhelper {:source, source, _opts} do
        Exd.QueryRunner.stream(source)
      end

    end
  end

end
