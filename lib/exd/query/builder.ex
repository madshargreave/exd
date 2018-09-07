defmodule Exd.Query.Builder do
  @moduledoc """
  Pipe API for constructing Exd.Query structs
  """
  alias Exd.Query

  def new do
    %Query{}
  end

  def from(query \\ %Query{}, name, source) do
    %Query{query | from: {name, source}}
  end

  def where(query \\ %Query{}, field, relation, value) do
    wheres = [{field, relation, value} | query.where]
    %Query{query | where: wheres}
  end

end
