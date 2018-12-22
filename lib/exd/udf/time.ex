defmodule Exd.UDF.Time do
  @moduledoc false
  alias Exd.UDF.Time

  def default do
    [
      Time.CurrentTimestamp,
    ]
  end

end
