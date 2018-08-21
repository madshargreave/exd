defmodule Exd.SchemaTest do
  use ExUnit.Case

  defmodule TestSchema do
    use Exd.Schema

    schema "person" do
      field :name, :string
      field :age, :integer
    end
  end

  describe "schema/2" do
    test "it defines module as a struct" do
      struct = %TestSchema{}
      assert struct.__meta__.source == "person"
      assert is_nil(struct.name)
      assert is_nil(struct.age)
    end

    test "it defines schema fields" do
      assert TestSchema.__schema__(:field, :name) == :name
      assert TestSchema.__schema__(:field, :age) == :age
    end
  end
end
