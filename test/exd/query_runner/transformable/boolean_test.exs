defmodule Exd.Transformable.BooleanTest do
  use ExUnit.Case
  alias Exd.Transformable

  describe "if" do
    test "it selects 'then' path if boolean is true" do
      assert 1 == Transformable.transform(2 > 1, {:if, 1, 2})
    end

    test "it selects 'else' path if boolean is false" do
      assert 2 == Transformable.transform(1 > 2, {:if, 1, 2})
    end
  end

end
