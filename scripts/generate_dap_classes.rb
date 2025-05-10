#!/usr/bin/env ruby
# Usage: ruby scripts/generate_dap_classes.rb
# Generates Ruby data classes from the Debug Adapter Protocol JSON schema.

require_relative "../lib/json_schema_class_generator"
require "json"

schema_path = File.expand_path("../vendor/debug-adapter-protocol/debugAdapterProtocol.json", __dir__)
out_path = File.expand_path("../lib/dap.rb", __dir__)

schema = JSON.parse(File.read(schema_path))
generator = JsonSchemaClassGenerator.new(schema)
output = generator.generate

File.write(out_path, output)
puts "Generated DAP classes in #{out_path}"
