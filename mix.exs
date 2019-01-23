defmodule Exd.MixProject do
  use Mix.Project

  def project do
    [
      app: :exd,
      version: "0.1.36",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env),
      description: description(),
      package: package(),
      name: "Exd",
      source_url: "https://github.com/madshargreave/exd",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def elixirc_paths(:test), do: ["lib", "test/support"]
  def elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:flow, "~> 0.14"},
      {:atomic_map, "~> 0.8"},
      {:jason, "~> 1.1"},
      {:mix_test_watch, "~> 0.8", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false},
      {:mustache, "~> 0.3.0"},
      {:httpoison, "~> 1.0"},
      {:floki, "~> 0.20.0"},
      {:version_tasks, "~> 0.11.3"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description() do
    "A few sentences (a paragraph) describing the project."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "exd",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README*),
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/madshargreave/exd"}
    ]
  end

end
