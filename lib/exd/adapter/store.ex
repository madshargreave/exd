# defmodule Exd.Source.Store do
#   @moduledoc """
#   A source based on a state store
#   """
#   use Exd.Adapter

#   defstruct store_pid: nil

#   @impl true
#   def init(_) do
#     store_pid = Keyword.fetch(opts, :store_pid)
#     if !store_pid, do: raise ArgumentError, "`store_pid` is required"
#     {
#       :ok,
#       %__MODULE__{
#         store_pid: store_pid
#       }
#     }
#   end

#   @impl true
#   def from(state) do
#     Store.all(state.store_pid)
#   end

#   @impl true
#   def join(keys, state) do
#     Store.match(state.store_pid, keys)
#   end

# end
