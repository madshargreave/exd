defmodule Exd.Query.Builder do
  @moduledoc """
  API for constructing queries using macros
  """
  alias Exd.Query
  alias Exd.Query.Builder.{From, Where, Select}

  @doc """
  Escapes a from(a in b) expression

  ## Example

      iex> escape(quote do: var)
      {:binding, ["var"]}

      iex> escape(quote do: var.x)
      {:binding, ["var", "x"]}
  """
  # var - where var is bound
  def escape({binding, _, _}) when is_atom(binding) do
    {:binding, [do_escape(binding)]}
  end

  # var.x - where var is bound
  def escape({{:., _, [{binding, _, _}, field]}, _, _} = expr) do
    {:binding, [do_escape(binding), do_escape(field)]}
  end
  def escape(binding), do: binding

  defp do_escape({binding, _, _}) when is_atom(binding), do: escape(binding)
  defp do_escape(binding)
    when is_atom(binding), do: Atom.to_string(binding)


  @doc """
  Creates a query

  ## Keywords example

      from(n in [1, 2, 3], select: n)
  """
  defmacro from(expr, opts \\ []) do
    unless Keyword.keyword?(opts) do
      raise ArgumentError, "second argument to `from` must be a compile time keyword list"
    end
    {query, binds} = From.build(expr, __CALLER__)
    from(opts, __CALLER__, query, binds)
  end

  @binds ~w(where or_where select select_merge)a
  @functions ~w(add subtract multiply divide interpolate regex replace range unnest)a

  defp from([{:select, expr} | rest], env, query, binds) do
    from(
      rest,
      env,
      Select.build(query, binds, expr, env),
      binds
    )
  end

  defp from([{:where, expr} | rest], env, query, binds) do
    from(
      rest,
      env,
      Where.build(query, binds, expr, env),
      binds
    )
  end

  defp from([], _env, quoted, _binds) do
    Macro.escape(quoted)
  end

end
