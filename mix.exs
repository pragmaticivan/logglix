defmodule Logglix.Mixfile do
  use Mix.Project

  def project do
    [app: :logglix,
     version: "1.0.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: description(),
     package: package(),
     deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [
      {:credo, "~> 0.8.8", only: [:dev, :test]},
      {:ex_doc, ">= 0.18.1", only: :dev},
      {:httpoison, "~> 0.13.0"}
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
