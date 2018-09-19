defmodule Exd.Plugin.List do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Exd.Plugin.Adapter
    end
  end

end
