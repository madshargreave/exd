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
  def from(query \\ %Query{}, name, source) do
    %Query{query | from: {name, source}}
  end

  @doc """
  Add a join clause to query
  """
  @spec join(Query.t, binary, binary, binary, binary, binary) :: Query.t
  def join(query, type, name, source, left_key, right_key) do
    joins = query.joins ++ [%{
      type: type,
      from: {name, source},
      left_key: left_key,
      right_key: right_key
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
  def select(query, selection) do
    %Query{query | select: selection}
  end

  @doc """
  Set the select clause for query
  """
  @spec into(Query.t, term, keyword) :: Query.t
  def into(query, sink, opts \\ []) do
    intos = query.into ++ [{sink, opts}]
    %Query{query | into: intos}
  end

end
