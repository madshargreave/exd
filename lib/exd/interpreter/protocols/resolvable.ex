defprotocol Exd.Resolvable do
  @moduledoc """
  Transform Elixir primitive types into source and sink specs
  """
  @fallback_to_any true

  def resolve(value, record, env \\ %{})

end

defimpl Exd.Resolvable, for: BitString do
  def resolve(string, record, env) do
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
  def resolve({:arg, reference_or_literal}, record, env \\ %{}) do
    Map.fetch!(env, reference_or_literal)
  end
  def resolve(tuple, record, env) do
    resolved =
      tuple
      |> Tuple.to_list
      |> Enum.map(&Exd.Resolvable.resolve(&1, record, env))
      |> List.to_tuple

    # IO.inspect {resolved, Exd.Plugin.resolve(resolved)}
    {:ok, module} = Exd.Plugin.resolve(resolved)
    # IO.inspect resolved
    {:ok, calls} = module.handle_parse(resolved)
    {:ok, [result]} = module.handle_eval([calls])
    result
  end
  def resolve(_, record, env), do: record
end

defimpl Exd.Resolvable, for: List do
  def resolve(list, record, env \\ %{}) do
    result =
      for element <- list do
        case element do
          {key, value} ->
            {key, Exd.Resolvable.resolve(value, record, env)}
          element ->
            Exd.Resolvable.resolve(element, record, env)
        end
      end
    result
  end
end

defimpl Exd.Resolvable, for: Any do
  def resolve(value, _record, env \\ %{}), do: value
end
