defmodule Exd.Schema do
  @moduledoc """
  Defines an Exd source

  An Exd source is used to retrieve and transform external data sources
  into an continous stream of data

  ## Example

      defmodule Person do
        use Exd.Schema

        schema "person" do
          field :id, :string, primary: true
          field :name, :string
          field :age, :integer
        end
      end

  By default, Exd will use the name a field to retrieve the source data field. However,
  if these do not match, the custom `accessor` option can be used to create the mapping.
  """
  defstruct [:name, :fields]

  @doc false
  defmacro __using__(_opts) do
    quote do
      import Exd.Schema
      Module.register_attribute(__MODULE__, :exd_primary_keys, accumulate: true)
      Module.register_attribute(__MODULE__, :exd_fields, accumulate: true)
      Module.register_attribute(__MODULE__, :exd_field_sources, accumulate: true)
    end
  end

  @doc """
  Defines the source schema
  """
  defmacro schema(name, [do: block]) do
    quote do
      Module.register_attribute(__MODULE__, :struct_fields, accumulate: true)

      name = unquote(name)

      unless name do
        raise ArgumentError, "Exd source name must be a string, got: #{inspect name}"
      end

      Module.put_attribute(
        __MODULE__,
        :struct_fields,
        {:__meta__, %{source: name}}
      )

      try do
        unquote(block)
      after
        :ok
      end

      primary_keys = @exd_primary_keys |> Enum.reverse
      fields = @exd_fields |> Enum.reverse
      field_sources = @exd_field_sources |> Enum.reverse

      Module.eval_quoted(__ENV__, [
        Exd.Schema.__defstruct__(@struct_fields),
        Exd.Schema.__deffields__(fields)
      ])
    end
  end

  @doc """
  Defines a field on source with the given name and type
  """
  defmacro field(name, type, opts \\ []) do
    quote do
      Exd.Schema.__field__(__MODULE__, unquote(name), unquote(type), unquote(opts))
    end
  end

  @doc false
  def __field__(mod, name, type, opts) do
    accessor = opts[:accessor] || Atom.to_string(name)

    Module.put_attribute(mod, :struct_fields, {name, nil})
    Module.put_attribute(mod, :exd_fields, {name, type})
    Module.put_attribute(mod, :exd_field_sources, {name, accessor})
  end

  @doc false
  def __deffields__(fields) do
    quoted =
      fields
      |> Enum.map(fn {name, _type} ->
        quote do
          def __schema__(:field, unquote(name)) do
            unquote(name)
          end
        end
      end)
  end

  @doc false
  def __defstruct__(struct_fields) do
    quote do
      defstruct unquote(Macro.escape(struct_fields))
    end
  end

end
