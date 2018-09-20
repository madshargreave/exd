defmodule Exd.Plugin.Fetch.Client do
  @moduledoc false
  alias HTTPoison.Response

  def fetch(url, opts) do
    with {:ok, response} <- send_request(url, opts),
         {:ok, body} <- parse_body(response) do
      [
        %{
          "status" => response.status_code,
          "body" => body
        }
      ]
    end
  end

  defp send_request(url, opts) do
    HTTPoison.get(url)
  end

  defp parse_body(%Response{status_code: status, body: body}) do
    {:ok, body}
  end
  defp parse_body(_), do: :error

end
