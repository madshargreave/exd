defmodule Exd.PluginTest do
  use Exd.PluginCase,
    plugin: Exd.Plugin.String

  alias Exd.Query
  alias Exd.Repo

  describe "from" do
    test "it generates records using plugin" do
      assert [
        %{greeting: "hello Jack"},
        %{greeting: "hello John"},
        %{greeting: "hello Mads"}
      ] ==
        Query.new
        |> Query.from(
          "people",
          [
            %{"name" => "jack"},
            %{"name" => "john"},
            %{"name" => "mads"}
          ]
        )
        |> Query.select(%{
          greeting: {:interpolate, "'hello {{name}}'", name: {:capitalize, "people.name"}}
        })
        |> Repo.run
    end
  end

end
