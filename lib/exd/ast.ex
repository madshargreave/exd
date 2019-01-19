defmodule Exd.AST do
  @moduledoc """
  AST node definitions
  """

  defmodule Node do
    @doc false
    defmacro __using__(fields) do
      quote bind_quoted: [fields: fields] do
        @moduledoc false
        defstruct fields
        @derive {Poison.Encoder, only: fields}
        @type t :: %__MODULE__{}
      end
    end
  end

  defmodule Program do
    use Node, [:config, :ctes, :insert, :query]
  end

  defmodule Query do
    @moduledoc false
    use Node, [:select, :from, :group_by, :window]
  end

  defmodule CommonTableExpr do
    @moduledoc false
    use Node, [:identifier, :expr]
  end

  defmodule InsertExpr do
    @moduledoc false
    use Node, [:into]
  end

  defmodule SelectExpr do
    @moduledoc false
    use Node, [:columns, :into]
  end

  defmodule TableExpr do
    @moduledoc false
    use Node, [:name, :expr, :where]
  end

  defmodule WhereExpr do
    @moduledoc false
    use Node, [:conditions]
  end

  defmodule GroupByExpr do
    @moduledoc false
    use Node, [:columns, window: nil]
  end

  defmodule ColumnExpr do
    @moduledoc false
    use Node, [:names, :expr]
    def names(%__MODULE__{names: [], expr: %{column_name: name}}), do: [name.value]
    def names(%__MODULE__{names: names}), do: for name <- names, do: name.value
  end

  defmodule ColumnRef do
    @moduledoc false
    use Node, [:family, :column_name, :all]
  end

  defmodule BindingExpr do
    @moduledoc false
    use Node, [:family, :identifier]
  end

  defmodule CallExpr do
    @moduledoc false
    use Node, [:identifier, :params]
  end

  defmodule InfixExpr do
    @moduledoc false
    use Node, [:operator, :left, :right]
  end

  defmodule Operator do
    @moduledoc false
    use Node, [:value]
  end

  defmodule NumberLiteral do
    @moduledoc false
    use Node, [:value]
  end

  defmodule StringLiteral do
    @moduledoc false
    use Node, [:value]
  end

  defmodule Identifier do
    @moduledoc false
    use Node, [:value]
  end

  defmodule TableIdentifier do
    @moduledoc false
    use Node, [:value]
  end

  defmodule InfixOperation do
    @moduledoc false
    use Node, [:operator, :left, :right]
  end

end
