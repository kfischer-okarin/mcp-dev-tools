require "model_context_protocol"
require "model_context_protocol/transports/stdio"

server = MCP::Server.new(name: "dev_tools")
transport = MCP::Transports::StdioTransport.new(server)
transport.open
