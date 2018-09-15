defprotocol Exd.Specable do
  @moduledoc """
  Transform Elixir primitive types into source and sink specs
  """

  def to_spec(specable)

end

alias Exd.Source.Function, as: SourceFunction
alias Exd.Source.List, as: SourceList

defimpl Exd.Specable, for: List do
  def to_spec(list) do
    {
      SourceList,
        value: list
    }
  end
end


defimpl Exd.Specable, for: Function do
  def to_spec(func) do
    {
      SourceFunction,
        fn: func
    }
  end
end

defimpl Exd.Specable, for: Tuple do
  def to_spec({module, opts}) do
    {module, opts}
  end
end
