# defmodule Exd.Source.Crawler do
#   @moduledoc """
#   Fetches and parses data from a static HTML website
#   """
#   require Logger
#   use Exd.Adapter

#   defstruct done: nil,
#             url: nil,
#             container: nil,
#             mapping: nil

#   @impl true
#   def init(context, opts) do
#     url = Keyword.fetch!(opts, :url)
#     container = Keyword.fetch!(opts, :container)
#     mapping = Keyword.fetch!(opts, :mapping)

#     {
#       :ok,
#       %__MODULE__{
#         done: false,
#         url: url,
#         container: container,
#         mapping: mapping
#       }
#     }
#   end

#   @impl true
#   def paginate(%{done: true}), do: :done
#   def paginate(state) do
#     with {:ok, raw} <- download_page(state.url),
#          {:ok, items} <- parse_markup(raw, state.container, state.mapping) do
#       new_state = %__MODULE__{state | done: true}
#       {:ok, items, new_state}
#     end
#   end

#   defp download_page(url) do
#     # Logger.info "Download #{url}"
#     case HTTPoison.get(url) do
#       {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
#         {:ok, body}
#       {:ok, %HTTPoison.Response{status_code: 404}} ->
#         {:error, :not_found}
#       {:error, %HTTPoison.Error{reason: reason}} ->
#         {:error, reason}
#     end
#   end

#   defp parse_markup(content, container, mapping) do
#     # Logger.info "Parsing response..."
#     # IO.inspect container
#     # IO.inspect mapping
#     # IO.inspect Floki.find(content, container)
#     parsed =
#       content
#       # |> IO.inspect
#       |> Floki.find(container)
#       # |> IO.inspect
#       |> Enum.map(fn item ->
#         case item do
#           {name, attributes, children} ->
#             # IO.inspect item
#             mapping
#             |> Enum.reduce(%{}, fn {name, field}, acc ->
#               value =
#                 field
#                 |> Enum.reduce(item, fn option, value ->
#                   case option do
#                     {:access, path} ->
#                       Floki.find(value, path) |> Floki.text
#                     {:regex, regex} ->
#                       [group] = Regex.run(regex, value, global: true, capture: :all_but_first)
#                       group
#                     {:replace, {pattern, replacement}} ->
#                       String.replace(value, pattern, replacement)
#                     {:cast, type} ->
#                       case type do
#                         :float -> String.to_float(value)
#                         :integer -> String.to_integer(value)
#                       end
#                     {:trim, _} ->
#                       String.trim(value)
#                   end
#                 end)
#               Map.put(acc, "#{name}", value)
#             end)
#         end
#       end)
#       # |> IO.inspect
#     {:ok, parsed}
#     # {
#     #   :ok,
#     #   [
#     #     %{"name" => "bitcoin", "symbol" => "btc", "marketcap" => Enum.random([42500000, 52500000])},
#     #     %{"name" => "ethereum", "symbol" => "eth", "marketcap" => 15000000}
#     #   ]
#     # }
#   end

# end
