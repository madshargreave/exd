defmodule Exd.UDF do
  @moduledoc """
  Behaviour for user defined functions
  """
  alias Exd.UDF

  @doc """
  Evaluates a resolved call expression
  """
  @callback eval(args :: [value]) ::
      value
    when value: any

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour Exd.Callable
      @behaviour Exd.UDF

      def stateful? do
        false
      end

      defoverridable stateful?: 0

    end
  end

  def default do
    [
      UDF.Integer.default(),
      UDF.List.default()
    ]
    |> Enum.concat()
  end

end
