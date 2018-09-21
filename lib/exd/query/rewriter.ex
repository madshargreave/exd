defmodule Exd.Query.Rewriter do
  @moduledoc """
  Performs a number of rewrites on query
  """
  alias Exd.Query

  @rules [
    Exd.Query.Rewriter.Rules.Interpolation,
    Exd.Query.Rewriter.Rules.Unnest
  ]

  @spec rewrite(Query.t()) :: Query.t()
  def rewrite(query) do
    query
    |> rewrite_select
  end

  defp rewrite_select(%Query{select: select} = query) when is_map(select) do
    {select, query} =
      select
      |> Enum.reduce({%{}, query}, fn {key, value}, {select_acc, outer_query_acc} ->
        {rewritten_value, rewritten_query} =
          @rules
          |> Enum.reduce({value, outer_query_acc}, fn rule, {value_acc, query_acc} ->
            rule.rewrite(key, value_acc, query_acc)
          end)
        {Map.put(select_acc, key, rewritten_value), rewritten_query}
      end)

    %Query{query | select: select}
  end
  defp rewrite_select(query), do: query

end
