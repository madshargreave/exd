defmodule Exd.Plugin do
  @moduledoc false
  alias Exd.Plugin.String.{
    Capitalize,
    Cast,
    Downcase,
    Upcase,
    Interpolate,
    Regex,
    Replace,
    Trim
  }
  alias Exd.Plugin.List.Range
  alias Exd.Plugin.Fetch

  # A list of standard plugins
  @default_plugins [
    # Strings
    Capitalize,
    Cast,
    Downcase,
    Upcase,
    Interpolate,
    Regex,
    Replace,
    Trim,
    # List
    Range,
    # Fetch
    Fetch,
  ]

  @loaded_plugins @default_plugins ++ Application.get_env(:exd, :plugins, [])

  @doc """
  Initializes the state of the plugin
  """
  @callback init(tuple()) :: {:ok, any()}

  @doc """
  Transforms a query expresion into a struct
  """
  @callback handle_parse(tuple()) :: {:ok, any()} | :ignore

  @doc """
  Evaluates a batch of the transformed structs
  """
  @callback handle_eval(any(), any()) :: {:ok, any()} | :error

  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour Exd.Plugin
      @before_compile Exd.Plugin
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def match?(expr) do
        case __MODULE__.handle_parse(expr) do
          {:ok, _} -> true
          _ -> false
        end
      end
      def handle_parse(_) do
        :ignore
      end
    end
  end

  @doc """
  Resolves the plugin that handles a particular expression
  """
  def resolve(expr) do
    case Enum.find(@loaded_plugins, &(&1.match?(expr))) do
      nil -> :error
      module -> {:ok, module}
    end
  end

end
