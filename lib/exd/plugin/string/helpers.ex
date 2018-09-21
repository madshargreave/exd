defmodule Exd.Plugin.String.Helpers do
  @moduledoc false

  @doc """
  Replace pattern with replacement in string
  """
  def replace(string, pattern, replacement) do
    String.replace(string, pattern, replacement)
  end

  @doc """
  Interpolates bindings into string
  """
  def interpolate(string, binding) when is_binary(binding), do: interpolate(string, [binding])
  def interpolate(string, bindings) do
    bindings
    |> Enum.reduce(string, fn replacement, acc ->
      acc
      |> String.replace("?", replacement, global: false)
    end)
  end

  @doc """
  Capture and return group from string
  """
  def regex(string, %Regex{} = regex), do: do_regex(string, regex)
  def regex(string, regex) when is_binary(regex) do
    {:ok, regex} = Regex.compile(regex)
    do_regex(string, regex)
  end
  defp do_regex(string, regex) do
    case Regex.run(regex, string, global: true, capture: :all_but_first) do
      [group] -> group
      _ -> nil
    end
  end

  @doc """
  Trim whitespace
  """
  def trim(string) do
    String.trim(string)
  end

  @doc """
  It downcases string
  """
  def downcase(string) do
    String.downcase(string)
  end

  @doc """
  It upcases string
  """
  def upcase(string) do
    String.upcase(string)
  end

  @doc """
  It capitalizes string
  """
  def capitalize(string) do
    String.capitalize(string)
  end

  @doc """
  It casts string to type
  """
  def cast("", _type), do: nil
  def cast(string, type) do
    case type do
      :float -> String.to_float(string)
      :integer ->
        string
        |> String.replace(",", "")
        |> String.to_integer
    end
  end

end
