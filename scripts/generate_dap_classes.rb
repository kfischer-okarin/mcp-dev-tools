# frozen_string_literal: true

require "json"
require_relative "../lib/json_schema_class_generator"

schema_path = File.expand_path("../vendor/debug-adapter-protocol/debugAdapterProtocol.json", __dir__)
output_path = File.expand_path("../lib/dap.rb", __dir__)

schema = JSON.parse(File.read(schema_path), symbolize_names: true)
generator = JSONSchemaClassGenerator.new(schema)
generated_code = generator.generate

File.write(output_path, generated_code)
