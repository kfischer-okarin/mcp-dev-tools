# My MCP Server
## Installation

### Requirements
- (Technically optional) [`just`](https://github.com/casey/just) for easy command execution

### Install gems
```sh
just install
```

### Set environment variables
```sh
cp .env.template .env
```

and add all necessary values

### Add to MCP Client
#### Claude
```json
{
  "mcpServers": {
    "my_mcp_server": {
      "command": "just",
      "args": [
        "-f",
        "/absolute/path/to/my-mcp-server/Justfile",
        "run"
      ]
    }
  }
}
```
