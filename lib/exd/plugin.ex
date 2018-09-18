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
  require Logger

  # Default plugins
  use Exd.Plugin.String
  use Exd.Plugin.Integer
  use Exd.Plugin.Boolean

  def load_plugin do
    Application.get_env(:exd, :plugin, __MODULE__)
  end

  def __helper__(expr) do
    raise ArgumentError, message: "No plugin matches expression: #{inspect expr}"
  end

end
