defprotocol Exd.Parseable do
  @moduledoc """
  Defines protocol for parsing data structures into Exd.Query
  """
  def parse(data)
end
