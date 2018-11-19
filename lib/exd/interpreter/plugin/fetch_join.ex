defmodule Exd.Plugin.Fetch do
  @moduledoc """
  Source plugin that sends of remote HTTP requests and returns results

  `fetch` returns a struct containing the status, content and any other metadata
  related to the response

  * `status` - The status code of the request
  * `body` - The raw body of the request

  ## Options

  `fetch` takes the following static configuration options. Note
  that each of these can be overriden at runtime

    * `concurrency` - The max number of requests at any given time
    * `retries` - The number of times to retry failed requests
    * `timeout` - The number of milliseconds to wait before timing out requests

  ## Example

  When using `fetch` as a source

      [
        %Record{value: %{status: 200, body: "<html>...</html>"}}
      ] =
        Query.new
        |> Query.from("response", {:fetch, "'https://coinmarketcap.com'""})
        |> Query.select(%{
          status: "response.status",
          body: "response.body"
        })
        |> Query.to_list

  When setting static configuration options

      [
        %Record{value: %{symbol: "btc", html: "..."}},
        %Record{value: %{symbol: "eth", html: "..."}},
        %Record{value: %{symbol: "xrp", html: "..."}}
      ] =
        Query.new
        |> Query.set("fetch.concurrency", 5)
        |> Query.from("symbol", ["btc", "eth", "xrp"])
        |> Query.join("responses", {:fetch, "'https://coinmarketcap.com/currencies/{{symbol}}'"})
        |> Quere.where("responses.status", :<, 300)
        |> Query.select(%{
          symbol: "symbol",
          html "responses.body"
        })

  When using `fetch` as a join

      Query.new
      |> Query.from("symbol", ["btc", "eth", "xrp"])
      |> Query.join("responses", {:fetch, "'https://coinmarketcap.com/currencies/{{symbol}}'"})
      |> Query.select(%{...})
  """
  use Exd.Plugin
  use GenStage

  alias Exd.Plugin.Fetch.Client, as: Client

  @default_concurrency 1
  @default_retries 0
  @default_timeout 5000

  # Client

  def start_link(opts \\ []) do
    GenStage.start_link(__MODULE__, opts)
  end

  @impl true
  def handle_parse({:fetch, url}), do: handle_parse({:fetch, url, []})
  def handle_parse({:fetch, url, opts}) do
    opts = Keyword.put(opts, :url, url)
    spec = {__MODULE__, opts}
    {:ok, spec}
  end

  # Server

  @impl true
  def init(opts) do
    state = %{}
    {:producer_consumer, state}
  end

  @impl true
  def handle_events(events, state) do
    urls = for event <- events, do: Map.fetch(event, :url)
    client = get_client()
    events = Client.fetch(client, urls)
    {:noreply, events, state}
  end

  defp get_client(opts \\ []) do
    Client.new(
      concurrency: Keyword.get(opts, :concurrency, @default_concurrency),
      retries: Keyword.get(opts, :retries, @default_retries),
      timeout: Keyword.get(opts, :timeout, @default_timeout)
    )
  end

end
