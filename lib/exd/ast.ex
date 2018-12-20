defmodule Exd.AST do
  @moduledoc """
  AST node definitions
  """

  defmodule Program do
    @moduledoc false
    defstruct [:config, :query]
  end

  defmodule Query do
    @moduledoc false
    defstruct [:select, :from]
  end

  defmodule SelectExpr do
    @moduledoc false
    defstruct [:columns, :into]
  end

  defmodule TableExpr do
    @moduledoc false
    defstruct [:name, :expr]
  end

  defmodule ColumnExpr do
    @moduledoc false
    defstruct [:name, :expr]
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
    defstruct [:identifier, :arguments]
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

end
