# ConfigServer

**This project is in alpha status. No stability guarantees are made.**

ConfigServer is my attempt at standardizing a pattern that I use regularly: An [Agent](https://hexdocs.pm/elixir/1.13/Agent.html) 
that transparently keeps its state persisted to a file on disk. The intent is to support multiple different storage 
formats, including :erlang.term_to_binary, and YAML.

## Installation
```elixir
def deps do
  [
    {:config_server, git: "https://github.com/bo0tzz/config_server.git"}
  ]
end
```

## Usage:
Define a module to hold your code for using the config server. In it, include a child_spec like so:
```elixir
def child_spec(arg) do
  options =
    [
      name: __MODULE__,
      path: "./state.db",
      default_fn: fn -> %{} end,
      storage: ConfigServer.Storage.BinaryTerm
    ]
    |> Keyword.merge(arg)

  %{
    id: __MODULE__,
    start: {ConfigServer, :start_link, [options]}
  }
end
```

Then, use it from other functions like so:
```elixir
def save_task(%{id: id} = task) do
  ConfigServer.update(__MODULE__, &Map.put(&1, id, task))
end
```

The get, update, etc functions on the ConfigServer module relate directly to the functions on [Agent](https://hexdocs.pm/elixir/1.13/Agent.html).
Refer to [the Agent docs](https://hexdocs.pm/elixir/1.13/Agent.html) for more info.