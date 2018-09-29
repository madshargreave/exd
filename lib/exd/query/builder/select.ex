defmodule Exd.Query.Builder.Select do
  @moduledoc false
  alias Exd.Query.Builder
  alias Exd.Query

  @doc """
  Handles `select` expressions

  The expressions may either contain an `in` expression or not.
  The right side is always expected to Queryable.
  """

  # Binding
  def escape({{:., _, [binding, field]}, _, []}, env) do
    {_, [binding]} = escape(binding, env)
    field = Atom.to_string(field)
    {:binding, [binding, field]}
  end
  def escape({binding, _, nil}, env) when is_atom(binding) do
    binding = Atom.to_string(binding)
    {:binding, [binding]}
  end

  # Map
  def escape({:%{}, _, pairs}, env) do
    pairs = escape_pairs(pairs, env)
    {:%{}, [], pairs}
  end

  # Function
  def escape({name, _, args}, env) when is_atom(name) and is_list(args) do
    {name, escape(args, env)}
  end

  def escape(args, env) when is_list(args) do
    for arg <- args, do: escape(arg, env)
  end

  def escape(other, _env), do: other

  defp escape_pairs(pairs, env) do
    pairs
    |> Enum.map(fn {key, value}->
      value = escape(value, env)
      {key, value}
    end)
  end

  @doc """
  Builds select clause
  """
  def build(query, binds, select_expr, env) do
    select = escape(select_expr, env)
    Builder.apply_query(query, __MODULE__, [select], env)
  end

  def apply(%Query{select: nil} = query, expr) do
    %{query | select: expr}
  end

end
