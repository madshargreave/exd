defprotocol Exd.Valueable do
  @moduledoc """
  Valuates
  """
  @fallback_to_any true

  def evaluate(value, context \\ %{})

end

defimpl Exd.Valueable, for: BitString do
  def evaluate(string, context) do
    contains_quotes? = String.contains?(string, "'")

    if contains_quotes? do
      String.replace(string, ~r/\'/, "", global: true)
    else
      path = String.split(".")
      Kernel.get_in(context, path)
    end
  end
end

defimpl Exd.Valueable, for: Integer do
  def evaluate(integer, _context) do
    integer
  end
end

defimpl Exd.Valueable, for: Any do
  def evaluate(boolean, _context) when is_boolean(boolean) do
    boolean
  end
  def evaluate(nil, _context) do
    nil
  end
end
