# frozen_string_literal: true

require 'json'
require_relative 'test_helper'
require_relative '../lib/json_schema_class_generator'

# SUMMARY: class JSONSchemaClassGenerator
# SUMMARY: This class generates Data classes from a JSON schema.
# SUMMARY: It is used to create classes for the Debug Adapter Protocol (DAP).
# <spec>
# - It takes a JSON schema as loaded via `JSON.load_file` with symbol keys as a single constructor argument.
# - Generation will be done via a `generate` instance method which should return the generated Ruby code as a string.
# - It only needs to be able to handle the schema at vendor/debug-adapter-protocol/debugAdapterProtocol.json
# - It should create a value object class using `Data.define` for each definition in the schema.
# </spec>

class TestJSONSchemaClassGenerator < Minitest::Test
  def test_initialize_with_symbol_keys
    schema = { title: 'Example', type: 'object' }
    assert JSONSchemaClassGenerator.new(schema)
  end

  def test_responds_to_generate
    schema = { title: 'Example', type: 'object' }
    generator = JSONSchemaClassGenerator.new(schema)
    assert_respond_to generator, :generate
  end

  def test_generate_returns_string
    schema = { title: 'Example', type: 'object', definitions: {} }
    generator = JSONSchemaClassGenerator.new(schema)
    result = generator.generate
    assert_kind_of String, result
  end

  def test_generate_includes_data_define_for_protocol_message
    dap_schema = JSON.load_file(File.expand_path('../vendor/debug-adapter-protocol/debugAdapterProtocol.json', __dir__), symbolize_names: true)
    generator = JSONSchemaClassGenerator.new(dap_schema)
    code = generator.generate
    # Should define a Data class for ProtocolMessage
    assert_match(/ProtocolMessage\s*=\s*Data\.define/, code)
  end
end
