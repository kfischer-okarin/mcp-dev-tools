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


describe JSONSchemaClassGenerator do
  it 'can be initialized with a JSON schema loaded with symbol keys' do
    # Arrange
    schema = { title: 'Example', type: 'object' }

    # Act
    generator = JSONSchemaClassGenerator.new(schema)

    # Assert
    value(generator).must_be_instance_of JSONSchemaClassGenerator
  end

  it 'returns Ruby code as a string from #generate' do
    # Arrange
    schema = { title: 'Example', type: 'object', definitions: {} }
    generator = JSONSchemaClassGenerator.new(schema)

    # Act
    result = generator.generate

    # Assert
    value(result).must_be_kind_of String
  end

  it 'creates a Data.define class for each definition in the schema' do
    # Arrange
    dap_schema = JSON.load_file(TestHelper.path_relative_from_project_root('vendor/debug-adapter-protocol/debugAdapterProtocol.json'), symbolize_names: true)
    generator = JSONSchemaClassGenerator.new(dap_schema)

    # Act
    code = generator.generate

    # Assert
    value(code).must_match(/ProtocolMessage\s*=\s*Data\.define/)
  end
end
