defmodule Exd.Query do
  @moduledoc """
  Defines the Query data structure and provides the Query DSL.
  """
  defstruct materialize: nil,
            from: nil,
            joins: [],
            select: nil,
            select_merge: nil,
            where: [],
            or_where: [],
            into: nil,
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

end
