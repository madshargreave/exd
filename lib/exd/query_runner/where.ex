defmodule Exd.Runner.Where do
  @moduledoc """
  Where clause
  """
  alias Exd.Resolvable
  alias Exd.Record

  @type resolvable :: binary()
  @type relation :: :> | :< | := | :<>
  @type value :: any()

  @doc """
  Resolves select statement
  """
  @spec where(Flow.t(), resolvable(), relation(), value()) :: Flow.t()
  def where(flow, field, relation, value) do
    flow
    |> Flow.map(&mark_as_filtered(&1, field, relation, value))
    |> Flow.reject(&Record.flag?(&1, :filtered))
  end

  defp mark_as_filtered(record, field, relation, value) do
    if match?(record, field, relation, value) do
      record
    else
      Record.flag(record, :filtered)
    end
  end

  defp match?(record, field, relation, value) do
    left = Resolvable.resolve(field, record)
    right = Resolvable.resolve(value, record)
    do_match?(relation, left, right)
  end
  defp do_match?(:>, left, right), do: left > right
  defp do_match?(:<, left, right), do: left < right
  defp do_match?(:=, left, right), do: left = right
  defp do_match?(:<>, left, right), do: left != right

end
