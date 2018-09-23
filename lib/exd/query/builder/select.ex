defmodule Exd.Query.Builder.Select do
  @moduledoc false
  alias Exd.Query.API
  alias Exd.Query

  def build({:in, _meta, [{binding, _meta, nil}, source]}, caller, as) do
    %Query{
      from: {Atom.to_string(binding), Exd.Query.API.quote_expr(source), []}
    }
  end

end
