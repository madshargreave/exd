defmodule Exd.Query.Rewriter.Rule do
  @moduledoc """
  Behaviour for rewriter rules
  """
  alias Exd.Query

  @doc """
  Rewrites value and optionally the query based on rule
  """
  @callback rewrite(binary() | term(), any(), Query.t()) :: {any(), Query.t()}

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour Exd.Query.Rewriter.Rule
      @before_compile Exd.Query.Rewriter.Rule
    end
  end

  @doc false
  defmacro __before_compile__(_env) do
    quote do
      def rewrite(key, value, query) do
        {value, query}
      end
    end
  end

end
