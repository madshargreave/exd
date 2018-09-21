defmodule Exd.Query.Rewriter.Rules.Interpolation do
  @moduledoc """
  Rewrites interpolated string literals
  """
  use Exd.Query.Rewriter.Rule

  # Matches strings that looks like "hello {{people.name}}"
  @regex ~r/\{\{([a-zA-Z\.\_\-]+)\}\}/

  # Matches query arg "hello {{args.name}}"
  @args_regex ~r/\{\{args.([a-zA-Z\.\_\-]+)\}\}/

  @impl true
  def rewrite(_key, value, query) when is_binary(value) do
    cond do
      value =~ @regex ->
        captures = capture_interpolation_groups(value, query)
        value = replace_question_marks(value)
        {{:interpolate, value, captures}, query}
      true ->
        {value, query}
    end
  end

  defp capture_interpolation_groups(value, query) do
    @regex
    |> Regex.scan(value, capture: :all_but_first)
    |> List.flatten
    |> Enum.map(fn capture ->
        if String.match?(capture, ~r/^args.(.+)/) do
          case Regex.run(~r/^args.(.+)/, capture, capture: :all_but_first) do
            [key] when is_atom(key) ->
              "'#{query.env[Atom.to_string(key)]}'"
            [key] when is_binary(key) ->
              "'#{query.env[key]}'"
            _ ->
              capture
          end
        else
          capture
        end
    end)
  end

  defp replace_question_marks(value) do
    Regex.replace(@regex, value, "?")
  end

end
