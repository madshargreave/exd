defimpl Exd.Transformable, for: Integer do

  @doc """
  It adds numbers
  """
  def transform(left, {:add, right}) do
    left + right
  end

  @doc """
  It subtracts numbers
  """
  def transform(left, {:subtract, right}) do
    left - right
  end

  @doc """
  It multiplies numbers
  """
  def transform(left, {:multiply, right}) do
    left * right
  end

end
