defmodule Exd.Query.Builder.From do
  @moduledoc false
  alias Exd.Query.Builder
  alias Exd.Query

  @doc """
  Handles from expressions

  The expressions may either contain an `in` expression or not.
  The right side is always expected to Queryable.

  ## Example

      # iex> escape(quote do: n in [1, 2, 3])
      # {quote(do: n), [p: 0]}
  """
  @spec escape(Macro.t) :: {Macro.t, Keyword.t}
  def escape({:in, _, [var, source]}) do
    {Builder.escape_binding(var), escape_source(source)}
  end

  def escape_source({:%{}, _, keys_and_args}), do: for {key, arg} <- keys_and_args, into: %{}, do: {key, arg}
  def escape_source({:{}, _, func_and_args}), do: List.to_tuple(func_and_args)
  def escape_source(sources) when is_list(sources), do: for source <- sources, do: escape_source(source)
  def escape_source(source), do: source

  @doc """

  """
  def build(query, env) do
    {binding, queryable} = escape(query)
    {%Exd.Query{from: {binding, queryable, []}}, binding}
  end

end
