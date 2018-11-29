defmodule Exd.Query.Builder.Into do
  @moduledoc false
  alias Exd.Query.Builder
  alias Exd.Query

  @doc """
  Builds into clause
  """
  def build(query, binds, into_expr, env) do
    Builder.apply_query(query, __MODULE__, [into_expr], env)
  end

  def apply(%Query{into: nil} = query, into) do
    %{query | into: into}
  end

end
