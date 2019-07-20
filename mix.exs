defmodule Verbalex.MixProject do
  use Mix.Project

  @version "0.2.0"

  def project do
    [
      app: :verbalex,
      version: @version,
      package: package(),
      description: description(),
      elixir: "~> 1.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/tylerbarker/verbalex",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    """
    A library for creating complex, composable regular expressions with the reader & writer in mind.
    """
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.1", only: :dev},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:earmark, "~> 1.3", only: :dev},
      {:ex_doc, "~> 0.20.2", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      maintainers: ["Tyler Barker"],
      licenses: ["Apache 2.0"],
      links: %{
        "Source code" => "https://github.com/tylerbarker/verbalex"
      }
    ]
  end

  defp docs() do
    [
      main: "readme",
      name: "Verbalex",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/verbalex",
      source_url: "https://github.com/tylerbarker/verbalex",
      extras: [
        "README.md"
      ]
    ]
  end
end
