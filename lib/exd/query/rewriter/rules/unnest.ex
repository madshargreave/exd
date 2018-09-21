defmodule Exd.Query.Rewriter.Rules.Unnest do
  @moduledoc """
  Rewrites unnest keyword into a flattened query
  """
  use Exd.Query.Rewriter.Rule
  alias Exd.Query

  @impl true
  def rewrite(key, {:unnest, list} = value, %Query{select: selection} = query) do
    selection_without_unnest = Map.put(selection, key, list)
    flattened =
      query
      |> Query.flatten(query.flatten ++ [key])
      |> Query.select(selection_without_unnest)

    {list, flattened}
  end

end
