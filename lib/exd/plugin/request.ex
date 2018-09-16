defmodule Exd.Plugin.Request do
  @moduledoc """

  """
  defmacro __using__(_opts) do
    quote do
      import Exd.Plugin.Helpers
      alias Exd.Plugin.Request.Helpers

      defhelper {:http_call, method, url, data \\ %{}, params \\ [], headers \\ [], opts \\ []} do
        Helpers.http_call(method, url, data, params, headers, opts)
      end
    end
  end
end
