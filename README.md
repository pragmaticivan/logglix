Logglix
=================

A simple elixir `Logger` backend which sends logs to Loggly service.

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
  backends: [{Logglix, :loggly}, :console]

config :logger, :logglix,
  loggly_key: "your loggly key",
  tags: ["elixir"],
  level: :info
```


## Roadmap

[  ] Subscription by environment
