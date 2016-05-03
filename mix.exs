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
    [{:httpoison, "~> 0.8.1"}]
  end

  defp description do
    """
      Elixir loggly application event subscriber
    """
  end

  defp package do
    [
      maintainers: ["Ivan Santos"],
      licenses: ["ISC"],
      links: %{"Github": "https://github.com/pragmaticivan/logglix"}
    ]
  end
end
