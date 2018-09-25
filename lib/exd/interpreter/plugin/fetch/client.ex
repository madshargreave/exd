defmodule Exd.Plugin.Fetch.Client do
  @moduledoc false
  alias HTTPoison.Response

  defstruct concurrency: nil,
            retries: nil,
            timeout: nil

  def new(opts) do
    struct(__MODULE__, opts)
  end

  def fetch(client, urls) do
    {:ok, responses} = send_request(client, urls)
    for {:ok, response} <- responses,
        {:ok, body} <- parse_body(responses) do
      # [
        %{
          "status" => response.status_code,
          "body" => body
        }
      # ]
    end
  end

  defp send_request(client, urls) do
    responses = for url <- urls, do: HTTPoison.get(url)
    {:ok, responses}
  end

  defp parse_body(responses) when is_list(responses), do: for response <- responses, do: parse_body(response)
  defp parse_body({:ok, %Response{body: body}}) do
    {:ok, body}
  end

end
