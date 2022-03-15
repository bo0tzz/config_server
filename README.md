# ConfigServer

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `config_server` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:config_server, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/config_server>.

# Architecture
Library user starts up a supervised server, passing a storage path, and optionally an fn to generate default data and
a storage backend to use.
Multiple storage backends: straight term_to_binary, DETS, YAML/JSON etc
Server can be used like an Agent, with all changes automatically persisted