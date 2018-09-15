defmodule Exd.Query do
  @moduledoc """
  Defines the Query data structure and provides the Query DSL.
  """
  alias Exd.Query
  alias Exd.Query.Builder
  alias Exd.Query.Validator

  defstruct materialize: nil,
            from: nil,
            joins: [],
            select: nil,
            select_merge: nil,
            where: [],
            or_where: [],
            into: [],
            distinct: nil

  @typedoc "Query struct"
  @type t :: %__MODULE__{}

  @typedoc "Identifier"
  @type name :: binary()

  @typedoc "A queryable source"
  @type sourceable :: t() | term() | [t()] | [term()]

  @typedoc "From expression"
  @type from_expr :: {name(), sourceable()}

  @typedoc "Join expression"
  @type join_expr :: %{ from: from_expr(), left_key: term(), right_key: term() }

  @typedoc "Select expression"
  @type select_expr :: map()

  defdelegate new(), to: Builder
  defdelegate from(query \\ %Query{}, namespace, specable, opts \\ []), to: Builder
  defdelegate join(query, namespace, specable, opts \\ []), to: Builder
  defdelegate where(query, field, relation, value), to: Builder
  defdelegate select(query, selection), to: Builder
  defdelegate into(query, sink, opts \\ []), to: Builder
  defdelegate validate(queryable), to: Validator

end
