defprotocol Exd.Selectable do
  @moduledoc """
  Transform Elixir primitive types into source and sink specs
  """
  @fallback_to_any true

  def resolve(value, record)

end

defimpl Exd.Selectable, for: BitString do
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

defimpl Exd.Selectable, for: Any do
  def resolve(value, _record), do: value
end
