defmodule Exd.Source.File do
  @moduledoc """
  A source which iterates the results of a file

  ## Options

    * `:path` - File path
    * `:container` - Accessor for item container

  ## Usage

      defmodule MyFile do
        use Exd.Source,
          adapter: {
            Exd.Source.File,
              path: "test/support/fixtures/myfile.json""
          }
      end
  """
  use Exd.Adapter

  defstruct [
    path: nil,
    items: [],
    cursor: %{limit: 10}
  ]

  @type t :: %__MODULE__{}

  @doc """
  Loads file and parses items
  """
  @impl true
  def init(context, opts) do
    path = Keyword.fetch!(opts, :path)
    container = Keyword.fetch!(opts, :container)

    with {:ok, file_path} <- interpolate_context(path, context),
         {:ok, content}   <- read_file(path),
         {:ok, decoded}   <- decode_file_contents(content),
         {:ok, items}     <- parse_items(decoded, container),
         {:ok, merged}    <- merge_with_context(items, context) do
      state = %__MODULE__{path: path, items: items}
      {:ok, state}
    else
      _ ->
        :error
    end
  end

  @doc """
  Paginates list of items
  """
  @impl true
  def paginate(source) do
    case Enum.split(source.items, source.cursor.limit) do
      {[], _} ->
        :done
      {produced, remaining} ->
        state = %__MODULE__{source | items: remaining}
        {:ok, produced, state}
    end
  end

  defp interpolate_context(file_path, context) do
    {:ok, Mustache.render(file_path, context)}
  end

  defp read_file(file_path) do
    file_path
    |> File.read()
  end

  defp decode_file_contents(content) do
    Poison.decode(content)
  end

  defp parse_items(content, container) do
    {:ok, Kernel.get_in(content, [container])}
  end

  defp merge_with_context(items, context) do
    merged = for item <- items, do: Map.merge(item, context)
    {:ok, merged}
  end

end
