defmodule Exd.AST do
  @moduledoc """
  AST node definitions
  """

  defmodule Program do
    @moduledoc false
    defstruct [:config, :insert, :query]
  end

  defmodule Query do
    @moduledoc false
    defstruct [:select, :from, :group_by, :window]
  end

  defmodule InsertExpr do
    @moduledoc false
    defstruct [:into]
  end

  defmodule SelectExpr do
    @moduledoc false
    defstruct [:columns, :into]
  end

  defmodule TableExpr do
    @moduledoc false
    defstruct [:name, :expr]
  end

  defmodule GroupByExpr do
    @moduledoc false
    defstruct [:columns, window: nil]
  end

  defmodule ColumnExpr do
    @moduledoc false
    defstruct [:name, :expr]
    def name(%__MODULE__{name: nil, expr: %{column_name: name}}), do: name.value
    def name(%__MODULE__{name: name}), do: name.value
  end

  defmodule ColumnRef do
    @moduledoc false
    defstruct [:family, :column_name, :all]
  end

  defmodule BindingExpr do
    @moduledoc false
    defstruct [:family, :identifier]
  end

  defmodule CallExpr do
    @moduledoc false
    defstruct [:identifier, :params]
  end

  defmodule NumberLiteral do
    @moduledoc false
    defstruct [:value]
  end

  defmodule StringLiteral do
    @moduledoc false
    defstruct [:value]
  end

  defmodule Identifier do
    @moduledoc false
    defstruct [:value]
  end

  defmodule TableIdentifier do
    @moduledoc false
    defstruct [:value]
  end

end
