defmodule Exd.Plugin do
  @moduledoc """
  Defines helpers from both built-in and external Exd plugins
  """
  use Exd.Plugin.String
  use Exd.Plugin.Integer
  use Exd.Plugin.Boolean
end
