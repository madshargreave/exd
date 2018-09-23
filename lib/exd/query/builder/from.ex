defmodule Exd.Query.Builder.From do
  @moduledoc false
  alias Exd.Query.API
  alias Exd.Query

  def build({:in, _meta, [{binding, _meta, nil}, source]}, caller, as) do
    transformed = build_source(source)
    %Query{
      from: {Atom.to_string(binding), transformed, []}
    }
  end

  defp build_source([{:%{}, _, keys_and_values}]) do
    [(for {key, value} <- keys_and_values, into: %{}, do: {key, value})]
  end
  defp build_source({:{}, _, values}) do
    List.to_tuple(values)
  end
  defp build_source(source) do
    Exd.Query.API.quote_expr(source)
  end

end
