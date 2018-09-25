
defmodule Exd.QueryCase do
  @moduledoc false

  defmacro __using__(opts) do
    quote do
      use ExUnit.Case
      import Exd.Query.Builder
    end
  end

end
