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
  def escape_source({function, _, args}) when is_atom(function), do: List.to_tuple([function | escape_arg(args)])
  def escape_source(sources) when is_list(sources), do: for source <- sources, do: escape_source(source)
  def escape_source(expr) when is_tuple(expr) do
    for ele <- escape_source(Tuple.to_list(expr)) do
      case ele do
        ele when is_binary(ele) -> "'#{ele}'"
        _ -> escape_source(ele)
      end
    end |> List.to_tuple
  end
  def escape_source(source) when is_binary(source), do: source
  def escape_source(source) when is_atom(source), do: source
  def escape_source(source) when is_number(source), do: source

  def escape_arg(args) when is_list(args), do: for arg <- args, do: escape_arg(arg)
  def escape_arg(arg) when is_tuple(arg), do: escape_arg(Tuple.to_list(arg)) |> List.to_tuple
  def escape_arg(arg) when is_binary(arg), do: "'#{arg}'"
  def escape_arg(arg), do: arg
  # def escape_source(source), do: source

  @doc """

  """
  def build(query, env) do
    # IO.inspect query
    {binding, queryable} = escape(query)
    {%Exd.Query{from: {binding, queryable, []}}, binding}
  end

end
