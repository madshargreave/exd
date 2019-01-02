defmodule Exd.UDF.String do
  @moduledoc false
  alias Exd.UDF.String

  def default do
    [
      String.Integer,
      String.Regex
    ]
  end

end
