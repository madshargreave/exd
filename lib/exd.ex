defmodule Exd do
  @moduledoc """
  Ecto adapter for Exd library

  ## Example

    config :exd,
      plugins: [
        Exd.Plugin.Request,
        Exd.Plugin.JSON,
        Exd.Plugin.HTML,
        Exd.Plugin.XML,
        Exd.Plugin.RDMS
      ]
  """

end
