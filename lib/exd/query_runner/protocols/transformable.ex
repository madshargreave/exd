defprotocol Exd.Transformable do
  @moduledoc """
  Common utility functions
  """
  @fallback_to_any true

  def transform(value, func_and_args)

end
