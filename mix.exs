defmodule Logglix.Mixfile do
  use Mix.Project

  def project do
    [app: :logglix,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.11.0"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description do
    """
      Elixir loggly is a backend that forwards all log messages to the Loggly service.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md" ],
      maintainers: ["Ivan Santos"],
      licenses: ["MIT"],
      links: %{"Github": "https://github.com/pragmaticivan/logglix"}
    ]
  end
end
