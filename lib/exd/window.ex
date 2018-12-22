defmodule Exd.Codegen.Window do
  @moduledoc """
  Struct representing a unique window in a stream of records
  """
  defstruct keys: [],
            ts: nil
end
