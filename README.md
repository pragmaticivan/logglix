<h1 align="center">🎱 Logglix</h1>

<h5 align="center">A simple elixir Logger backend which sends logs to Loggly service.</h5>

<div align="center">
  <a href="https://hex.pm/packages/logglix">
    <img src="https://img.shields.io/hexpm/dt/logglix.svg?style=flat-square" alt="Hex" />
  </a>
</div>

## Installation

`Logglix` is a custom backend for the elixir `:logger` application. As
such, it relies on the `:logger` application to start the relevant processes.


Add logger_loggly_backend to your list of dependencies in `mix.exs`:
```elixir
def deps do
  [{:logglix, "~> 0.0.1"}]
end
```

Ensure logger_loggly_backend is started before your application:
```elixir
def application do
  [applications: [:logglix, :httpoison]]
end
```

Configure the logger
```elixir
config :logger,
  backends: [{Logglix, :logglix}, :console]

config :logger, :logglix,
  loggly_key: "your loggly key",
  tags: ["elixir"],
  level: :info
```

## Resources

* [Contributing Guide](https://github.com/pragmaticivan/logglix/blob/master/CONTRIBUTING.md)
* [Code of Conduct](https://github.com/pragmaticivan/logglix/blob/master/CODE_OF_CONDUCT.md)

## License

[MIT License](http://pragmaticivan.mit-license.org/) © Ivan Santos