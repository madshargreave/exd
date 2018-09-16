defmodule Exd.Transport.Request do
  @moduledoc """
  Transport based on data from a web request

  ## Options

    * `method` - HTTP method
    * `url` - HTTP url
    * `data` - Data to be sent as body
    * `params` - Data to be sent as request url parameters
    * `client` - HTTP client
    * `parser` - Data parser
  """
  use Exd.Source.Adapter

  @impl true
  def init(_) do
    {:ok, nil}
  end

  @impl true
  def send(_, state) do
    {:ok, state}
  end

end
