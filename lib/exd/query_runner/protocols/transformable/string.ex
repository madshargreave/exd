defimpl Exd.Transformable, for: BitString do

  @doc """
  Replace pattern with replacement in string
  """
  def transform(string, {:replace, pattern, replacement}) do
    String.replace(string, pattern, replacement)
  end

  @doc """
  Capture and return group from string
  """
  def transform(string, {:regex, regex}) do
    {:ok, regex} = Regex.compile(regex)
    case Regex.run(regex, string, global: true, capture: :all_but_first) do
      [group] -> group
      _ -> nil
    end
  end

  @doc """
  Trim whitespace
  """
  def transform(string, :trim) do
    String.trim(string)
  end

  @doc """
  It downcases string
  """
  def transform(string, :downcase) do
    String.downcase(string)
  end

  @doc """
  It casts string to type
  """
  def transform(string, {:cast, type}) do
    case type do
      :float -> String.to_float(string)
      :integer -> String.to_integer(string)
    end
  end

end
