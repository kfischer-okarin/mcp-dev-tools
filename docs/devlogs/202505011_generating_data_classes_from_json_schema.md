# Devlog: Generating Data classes from JSON schema (2025-05-11)

## Why I need this feature

- I want to add a tool for interacting with DAP compatible debuggers to this
  MCP server. For this I need to implement the DAP (or at least a first
  minimal subset). To be able to comfortably do this I want to have value
  objects representing the Protocol messages.

## Design Decision Log

- I chose data classes because they are offered by Ruby directly and seem to be
  a good simple choice for value objects.
