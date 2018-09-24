defmodule Exd.Query do
  @moduledoc """
  Defines the Query data structure and provides the Query DSL.
  """
  alias Exd.{Query, Repo}
  alias Exd.Query.Builder
  alias Exd.Query.Validator

  defstruct plugin_module: nil,
            materialize: nil,
            from: nil,
            joins: [],
            select: nil,
            select_merge: nil,
            flatten: [],
            where: [],
            or_where: [],
            into: nil,
            distinct: nil,
            env: %{}

  defmodule FromExpr do
    @moduledoc false
    defstruct as: nil, expr: nil
  end

  defmodule SelectExpr do
    @moduledoc false
    defstruct expr: nil
  end

  defmodule WhereExpr do
    @moduledoc false
    defstruct field: nil, relation: nil, expr: nil
  end

  defmodule FunctionExpr do
    @moduledoc false
    defstruct name: nil, arguments: []
  end

  @typedoc "Query struct"
  @type t :: %__MODULE__{}

  defdelegate first(query), to: Repo, as: :first

end
