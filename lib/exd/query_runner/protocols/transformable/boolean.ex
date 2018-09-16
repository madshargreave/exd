defimpl Exd.Transformable, for: Any do

  @doc """
  Replace pattern with replacement in string
  """
  def transform(boolean, {:if, a, b}) when is_boolean(boolean) do
    if boolean, do: a, else: b
  end

end
