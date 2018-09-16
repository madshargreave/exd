defprotocol Exd.Resolvable do
  @moduledoc """
  Transform Elixir primitive types into source and sink specs
  """
  @fallback_to_any true

  def resolve(value, record)

end

defimpl Exd.Resolvable, for: BitString do
  def resolve(string, record) do
    quoted? = String.contains?(string, "'")
    if quoted? do
      resolve_quoted(string)
    else
      resolve_ref(string, record)
    end
  end
  defp resolve_quoted(string), do: String.replace(string, ~r/\'/, "", global: true)
  defp resolve_ref(string, record) do
    path = String.split(string, ".")
    get_in(record.value, path)
  end
end

defimpl Exd.Resolvable, for: Tuple do
  def resolve({func, left, right}, record) when is_atom(func) do
    left = Exd.Resolvable.resolve(left, record)
    right = Exd.Resolvable.resolve(right, record)
    Exd.Plugin.__helper__({func, left, right})
  end
end

defimpl Exd.Resolvable, for: Any do
  def resolve(value, _record), do: value
end
