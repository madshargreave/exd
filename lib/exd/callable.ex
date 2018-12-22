defmodule Exd.Callable do
  @moduledoc """
  Defines a module that can be invoked as part of a `CallExpr`
  """

  @doc """
  Returns the identifier for the call expression
  """
  @callback name :: term

  @doc """
  Returns module implementation of call expression
  """
  def find(_identifier) do
    :ok
  end

end
