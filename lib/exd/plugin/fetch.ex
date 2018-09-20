defmodule Exd.Plugin.Fetch do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use Exd.Plugin.Adapter
      alias Exd.Plugin.Fetch.Client, as: FetchClient

      @impl true
      def apply({:fetch, url}), do: apply({:fetch, url, []})
      def apply({:fetch, url, opts}) do
        FetchClient.fetch(url, opts)
      end

    end
  end

end
