# Metrix

A tiny library to simplify measuring the execution time of code blocks.

## Overview

Metrix is a module you can `use` in your elixir applications to simplify
measuring and relaying the results to [Telemetry](https://github.com/beam-telemetry/telemetry).

When incorporated into your modules, you provide `measure/2` the event name to
send measurements to. `measure/2` sends the following data to your Telemetry
event handler:

- measurement: This is a `Map` with `:duration` as the key. The value is in
  microseconds
- metadata: Metadata is the value returned by the block of logic wrapped by
  `measure/2`. If the return value is not a map, `measure/2` returns it as a map
  with `:response` as the key. (e.g. `%{response: return_value}`).

### Example

Here's a simple example of how you might use Metrix. Below, we wrap a call to
`System.sleep/1` and `IO.puts/2` in the `#measure/2` macro. We also provide the
Telemetry event name against which we want to capture data. Whenever `run/0` is
executed it measures the elapsed time and reports the duration to any Telemetry
event handlers set up to match on `[:my_app, :event, :name]`.

```elixir
defmodule MyApp do
  use Metrix

  def run do
    measure([:my_app, :event, :name]) do
      System.sleep(1_000)
      IO.puts "Hello, World!"
    end
  end
end
```

An example event handler might look like this:

```elixir
def handle_event([:my_app, :event, :name], %{duration: duration}, metadata, _config) do
  IO.puts "#{duration}"
  IO.inspect metadata
end
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `metrix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:metrix, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/metrix](https://hexdocs.pm/metrix).

