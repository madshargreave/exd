defmodule Exd do
  @moduledoc """
  Ecto adapter for Exd library

  ## Example

    defmodule MyApp.Person do
      use Exd.Source,
        concurrency: 5,
        cache: :timer.minutes(60),
        adapter: {
          Exd.FileSource, file_path: "test/support/fixtures/people.json", container_path: "data"
        }

      field :id, :string, primary: true, accessor: "_id"
      field :country, :string,  accessor: "country"
      field :age, :integer,  accessor: "age"

      field :first_name, :string,
        accessor: "name",
        transforms: []

      field :last_name, :string
        accessor: "name",
        transforms: []

    end

    defmodule MyApp.Country do
      use Exd.Source,
        concurrency: 2,
        cache: :timer.hours(24),
        adapter: {
          Exd.FileSource, file_path: "test/support/fixtures/{{name}}.json", container_path: "data"
        }

      field :name, :string, accessor: "name"
      field :capital, :string, accessor: "capital",
      field :population, :string, "population"

    end

    defmodule MyApp.Repo do
      use Exd.Repo,
        concurrency: 10
    end
  """
  alias Exd.Query
  alias Exd.Repo
  alias Exd.Job

end
