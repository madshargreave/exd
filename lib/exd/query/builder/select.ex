defmodule Exd.Query.Builder.Select do
  @moduledoc false
  alias Exd.Query.Builder
  alias Exd.Query

  @doc """
  Handles `select` expressions

  The expressions may either contain an `in` expression or not.
  The right side is always expected to Queryable.

  ## Example

      # iex> escape(quote do: n)
      # {quote(do: n), [p: 0]}
  """
  @spec escape(Macro.t) :: {Macro.t, Keyword.t}
  def escape({binding, _, nil}), do: Atom.to_string(binding)
  def escape({:%{}, _, assignment}), do: for {key, expr} <- assignment, into: %{}, do: {key, escape_arg(expr)}
  def escape({func, _, args}) when is_atom(func) and is_list(args) do
    args = for arg <- args, do: escape_arg(arg)
    List.to_tuple([func] ++ args)
  end

  defp escape_arg(args) when is_list(args), do: for arg <- args, do: escape_arg(arg)
  defp escape_arg(arg) when is_binary(arg), do: "'#{arg}'"
  defp escape_arg({:sigil_r, _, [{_, _, [regex]}, _]}), do: Regex.compile!(regex)
  defp escape_arg({{:., _, [{binding, _, nil} | path]}, _, []}) do
    Enum.join([escape_arg(binding) | path], ".")
  end
  defp escape_arg({binding, _, nil}), do: Atom.to_string(binding)
  defp escape_arg({function, _, arguments} = expr) when is_atom(function), do: escape(expr)
  defp escape_arg(arg) when is_atom(arg), do: Atom.to_string(arg)
  defp escape_arg(arg), do: arg

  @doc """
  Builds select clause
  """
  def build(query, binding, expr, env) do
    # IO.inspect expr
    select = escape(expr)
    %Query{query | select: select}
  end

end
