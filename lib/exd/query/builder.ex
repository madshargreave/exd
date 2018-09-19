defmodule Exd.Query.Builder do
  @moduledoc """
  Pipe API for constructing Exd.Query structs
  """
  alias Exd.Query

  @doc """
  Create a new query
  """
  @spec new :: Query.t
  def new do
    %Query{}
  end

  @doc """
  Set the from clause for query
  """
  @spec from(Query.t, binary, any) :: Query.t
  def from(query \\ %Query{}, namespace, specable, opts \\ []) do
    %Query{query | from: {namespace, specable, opts}}
  end

  @doc """
  Add a join clause to query
  """
  @spec join(Query.t, binary, any, keyword) :: Query.t
  def join(query, namespace, specable, opts \\ []) do
    joins = query.joins ++ [%{
      from: {namespace, specable, opts}
    }]
    %Query{query | joins: joins}
  end

  @doc """
  Add a where clause to query
  """
  @spec where(Query.t, binary, term, any) :: Query.t
  def where(query, field, relation, value) do
    wheres = [{field, relation, value} | query.where]
    %Query{query | where: wheres}
  end

  @doc """
  Set the select clause for query
  """
  @spec select(Query.t, map) :: Query.t
  def select(query, selection) when is_map(selection) do
    selection
    |> Enum.reduce(%Query{query | select: selection}, fn {key, expr}, acc ->
      case expr do
        {:unnest, list} ->
          selection_without_unnest = Map.put(selection, key, list)
          acc
          |> flatten(acc.flatten ++ [key])
          |> select(selection_without_unnest)
        _ ->
          acc
      end
    end)
  end
  def select(query, selection), do: %Query{query | select: selection}

  @doc """
  Set the flatten options
  """
  @spec flatten(Query.t, [term]) :: Query.t
  def flatten(query, fields) do
    %Query{query | flatten: fields}
  end

  @doc """
  Set the select clause for query
  """
  @spec into(Query.t, term, keyword) :: Query.t
  def into(query, sink, opts \\ []) do
    %Query{query | into: {sink, opts}}
  end

end
