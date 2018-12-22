defmodule Exd.UDF.Integer do
  @moduledoc false
  alias Exd.UDF.Integer

  def default do
    [
      Integer.Add,
      Integer.Subtract,
      Integer.Multiply
    ]
  end

end
