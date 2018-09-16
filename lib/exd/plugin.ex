defmodule Exd.Plugin do
  @moduledoc """
  Defines helpers from both built-in and external Exd plugins

  ## Usage
    # inside config.exs
    config :exd,
      plugins: [
        Exd.Plugin.HTML,
        Exd.Plugin.XML
      ]
  """

  # Built-in plugins
  use Exd.Plugin.String
  use Exd.Plugin.Integer
  use Exd.Plugin.Boolean

  @external Application.get_env(:exd, :plugins, [])

  for plugin <- @external do
    quote do
      use unquote(plugin)
    end
  end

  def __helper__(expr) do
    raise ArgumentError, message: "No plugin matches expression: #{inspect expr}"
  end

end
