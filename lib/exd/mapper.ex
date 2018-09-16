defmodule Exd.Mapper do
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
  require Logger
  use GenStage

  defstruct adapter: nil,
            source_state: nil,
            namespace: nil

  def child_spec(args \\ []) do
    %{
      start: {__MODULE__, :start_link, [args]}
    }
  end

  def start_link(opts) do
    GenStage.start_link(__MODULE__, opts)
  end

  @impl true
  def init(opts) do
    {adapter, adapter_opts} = Keyword.fetch!(opts, :adapter)
    namespace = Keyword.fetch!(opts, :namespace)
    {:ok, source_state} = adapter.init(adapter_opts)

    {
      :producer_consumer,
      %__MODULE__{
        adapter: adapter,
        namespace: namespace,
        source_state: source_state
      }
    }
  end

  @impl true
  def handle_events(records, _from, state) do
    {:ok, results} = state.adapter.handle_join(records, state.source_state)
    results =
      records
      |> Enum.zip(results)
      |> Enum.map(fn {record, result} ->
        Exd.Record.put(record, state.namespace, result)
      end)
    :timer.sleep(100)
    {:noreply, results, state}
  end

  @impl true
  def handle_cancel(_, _from, state) do
    GenStage.async_info(self(), :terminate)
    {:noreply, [], state}
  end

  @impl true
  def handle_info(:terminate, state) do
    {:stop, :shutdown, state}
  end

end
