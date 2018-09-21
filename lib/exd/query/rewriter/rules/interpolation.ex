defmodule Exd.Query.Rewriter.Rules.Interpolation do
  @moduledoc """
  Rewrites interpolated string literals
  """
  use Exd.Query.Rewriter.Rule

  # Matches strings that looks like "hello {{people.name}}"
  @regex ~r/\{\{([a-zA-Z\.\_\-]+)\}\}/

  @impl true
  def rewrite(_key, value, query) when is_binary(value) do
    if value =~ @regex do
      captures = capture_interpolation_groups(value)
      value = replace_question_marks(value)
      {{:interpolate, value, captures}, query}
    else
      {value, query}
    end
  end

  defp capture_interpolation_groups(value) do
    @regex
    |> Regex.scan(value, capture: :all_but_first)
    |> List.flatten
  end

  defp replace_question_marks(value) do
    Regex.replace(@regex, value, "?")
  end

end
