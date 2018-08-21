defmodule Exd.Source do
  @moduledoc """
  Defines a source

  ## Options

    * `:adapter` - The source adapter module and options
    * `:concurrency` - The number of concurrent source connections

  ## Usage

      defmodule PersonSource do
        use Exd.Source,
          adapter: {
            Exd.Sources.File,
              file_path: "test/support/fixtures/people.json"
          }
      end
  """

  defmacro __using__(opts) do
    {provider, provider_opts} = Keyword.get(opts, :provider, {nil, []})
    {parser, parser_opts} = Keyword.get(opts, :parser, {nil, []})

    quote do
      require Logger
      use GenStage

      def start_link(context) do
        # Logger.info "Starting source #{__MODULE__}"
        GenStage.start_link(__MODULE__, context)
      end

      def insert(documents) do
        GenServer.call(__MODULE__, {:insert, documents})
      end

      def get_state(source) do
        GenServer.call(source, :get_state)
      end
      def get_state do
        GenServer.call(__MODULE__, :get_state)
      end

      @impl true
      def init(context) do
        Exd.Source.init(__MODULE__, context)
      end

      @impl true
      def handle_demand(demand, state) do
        Exd.Source.handle_demand(__MODULE__, demand, state)
      end

      @impl true
      def handle_call({:insert, documents}, _from, state) do
        Exd.Source.insert(__MODULE__, documents, state)
      end

      @impl true
      def handle_call(:get_state, _from, {_demand, _events, source_state} = state) do
        {:reply, source_state, [], state}
      end

      def __source__(:provider), do: {unquote(provider), unquote(provider_opts)}
      def __source__(:parser), do: {unquote(parser), unquote(parser_opts)}

    end
  end

  @doc """

  """
  def init(module, context) do
    {provider, provider_opts} = module.__source__(:provider)
    {:ok, source_state} = provider.init(context, provider_opts)
    {:producer, {0, [], source_state}}
  end

  @doc """

  """
  def handle_demand(module, demand, {
    buffered_demand,
    events,
    source_state
  } = _state) do
    {provider, provider_opts} = module.__source__(:provider)
    dispatch_events(provider, {
      demand + buffered_demand,
      events,
      source_state
    })
  end

  @doc """

  """
  def insert(module, documents, {
    demand,
    events,
    source_state
  }) do
    {provider, provider_opts} = module.__source__(:provider)
    case provider.insert(documents, source_state) do
      {:ok, source_state} ->
        dispatch_events(provider, {demand, events, source_state})
    end
  end

  @doc """

  """
  defp dispatch_events(provider, {
    demand,
    buffered_events,
    source_state
  } = state)
    when length(buffered_events) < demand
  do
    case provider.paginate(source_state) do
      {:ok, produced, new_source_date} ->
        dispatch_events(provider, {demand, buffered_events ++ produced, new_source_date})
      :done ->
        {:stop, :normal, state}
    end
  end

  @doc """

  """
  defp dispatch_events(_adapter, {
    demand,
    events,
    source_state
  } = _state)
    when length(events) >= demand
  do
    {events_to_dispatch, remaining_events} = Enum.split(events, demand)
    {:noreply, events_to_dispatch, {0, remaining_events, source_state}}
  end

end
