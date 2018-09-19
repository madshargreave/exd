
defmodule Exd.PluginCase do
  @moduledoc false

  defmacro __using__(opts) do
    module = Keyword.fetch!(opts, :plugin)
    quote do
      use ExUnit.Case

      defmodule MyPlugin do
        use unquote(module)
      end

      setup do
        Application.put_env(:exd, :plugin, MyPlugin)

        on_exit fn ->
          Application.put_env(:exd, :plugin, nil)
          :ok
        end

        :ok
      end
    end
  end

end
