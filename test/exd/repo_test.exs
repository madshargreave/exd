defmodule Exd.RepoTest do
  use ExUnit.Case

  defmodule TestRepo do
    use Exd.Repo
  end

  defmodule Person do
    use Exd.Schema

    schema "person" do
      field :name, :string
      field :age, :integer
    end
  end

  defmodule People do
    use Exd.Source,
      provider: {
        Exd.Source.List,
          value: (for i <- 0..10, do: %{"name" => "mads", "country" => "denmark", "age" => i})
      }
  end

  defmodule Country do
    use Exd.Source,
      provider: {
        Exd.Source.List,
          value: [
            %{"name" => "denmark", "population" => 2400000},
            %{"name" => "sweden", "population" => 2500000}
          ]
      }
  end

  describe "stream/2" do
    test "it defines module as a struct" do
      query = %Exd.Query{
        from: {"people", People},
        joins: [
          %{
            type: :inner,
            from: {
              "countries",
              [
                %{"name" => "denmark", "population" => 2400000},
                %{"name" => "sweden", "population" => 2500000}
              ]
          },
            left_key: "people.country",
            right_key: "countries.name"
          }
        ],
        select: %{
          "name" => "people.name",
          "age" => "people.age"
        }
      }

      assert [
        %{"name" => "mads", "age" => 0} | _rest
      ] =
        Exd.Repo.stream(query)
        |> Enum.sort
    end
  end
end
