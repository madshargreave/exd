defmodule Exd.Plugin do
  @moduledoc """
  Defines a UDF plugin
  """
  alias Exd.Record
  alias Exd.UDF.Integer, as: IntegerPlugin
  alias Exd.UDF.Time, as: TimePlugin
  alias Exd.Plugin.String, as: StringPlugin
  alias Exd.Plugin.List, as: ListPlugin
  alias Exd.Plugin.Fetch, as: FetchPlugin
  alias Exd.Plugin.Interval, as: IntervalPlugin

  # A list of standard plugins
  @default_plugins [
    # Integers
    IntegerPlugin.Multiply,
    # Strings
    # StringPlugin.Capitalize,
    # StringPlugin.Cast,
    # StringPlugin.Downcase,
    # StringPlugin.Upcase,
    # StringPlugin.Interpolate,
    # StringPlugin.Regex,
    # StringPlugin.Replace,
    # StringPlugin.Trim,
    # List
    ListPlugin.Range,
    # Time
    TimePlugin.CurrentTimestamp
  ]

  @doc """
  Invoked when the server is started for stateful plugins
  """
  @callback init(keyword) :: {:ok, state :: map}

  @doc """
  Invoked for all rows passing though the plugin

  Returns the transformed values as well as the updated state
  """
  @callback evaluate(records :: [record], state) ::
      {:ok, new_state}
      | {:stop, reason, new_state}
    when state: map, new_state: map, reason: term, record: Exd.record

  @doc false
  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      use GenStage

      @behaviour Exd.Callable
      @behaviour Exd.Plugin

      def start_link(opts) do
        GenStage.start_link(__MODULE__, opts)
      end

      @impl true
      def handle_cancel(_, _from, state) do
        GenStage.async_info(self(), :terminate)
        {:noreply, [], state}
      end

      @impl true
      def handle_info(:terminate, state) do
        {:stop, :normal, state}
      end

      defoverridable handle_cancel: 3, handle_info: 2
    end
  end

  @doc """
  Finds plugin
  """
  @spec find(binary | term) :: {:ok, term} | {:error, :not_found}
  def find(name) do
    loaded_plugins = @default_plugins ++ Application.get_env(:exd, :plugins, [])
    case Enum.find(loaded_plugins, fn module -> "#{module.name()}" == "#{name}" end) do
      nil -> {:error, :not_found}
      module -> {:ok, module}
    end
  end

  @doc """
  Check if plugin is stateful
  """
  def stateful?(name) do
    with {:ok, module} <- find(name) do
      module.stateful?()
    else
      _ ->
        false
    end
  end

end
