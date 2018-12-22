defmodule Exd.UDF.Time.CurrentTimestamp do
  @moduledoc """
  Multiply two numbers
  """
  use Exd.UDF

  @impl true
  def name do
    :current_timestamp
  end

  @impl true
  def eval([]) do
    {:ok, NaiveDateTime.utc_now()}
  end

end
