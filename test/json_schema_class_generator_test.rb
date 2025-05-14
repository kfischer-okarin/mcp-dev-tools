# frozen_string_literal: true

require "json"
require_relative "test_helper"
require_relative "../lib/json_schema_class_generator"

# SUMMARY: class JSONSchemaClassGenerator
# SUMMARY: This class generates Data classes from a JSON schema.
# SUMMARY: It is used to create classes for the Debug Adapter Protocol (DAP).
# <spec>
# - It takes a JSON schema as loaded via `JSON.load_file` with symbol keys as a single constructor argument.
# - Generation will be done via a `generate` instance method which should return the generated Ruby code as a string.
# - It needs to be able to process the schema at vendor/debug-adapter-protocol/debugAdapterProtocol.json without
#   errors.
# - It should create a value object class using `Data.define` for each definition in the schema.
# - Each generated data class should have all properties defined in the schema as attributes, the attributes should
#   be in snake case. Be sure to handle consecutive capital letters correctly: JSONValue -> json_value
# - A definition might be a combination of references to other definitions and own schemas. The generated class should
#   contain all properties of all referenced definitions as well.
# </spec>
#
# Test Instructions:
# - Make sure all test schemas have really symbol keys. Wrap them in TestHelper.deep_symbolize_keys to be sure.

describe JSONSchemaClassGenerator do
  it "includes all properties from referenced definitions and own schema in the generated class" do
    # Arrange
    schema = TestHelper.deep_symbolize_keys({
      definitions: {
        Base: {
          type: "object",
          properties: {
            "BaseProperty" => {type: "string"}
          }
        },
        Combined: {
          allOf: [
            {"$ref" => "#/definitions/Base"},
            {
              type: "object",
              properties: {
                "OwnProperty" => {type: "integer"}
              }
            }
          ]
        }
      }
    })
    generator = JSONSchemaClassGenerator.new(schema)

    # Act
    code = generator.generate

    # Assert
    value(code).must_match(/Combined\s*=\s*Data\.define\(:base_property, :own_property\)/)
  end
  it "can be initialized with a JSON schema loaded with symbol keys" do
    # Arrange
    schema = {title: "Example", type: "object"}

    # Act
    generator = JSONSchemaClassGenerator.new(schema)

    # Assert
    value(generator).must_be_instance_of JSONSchemaClassGenerator
  end

  it "returns Ruby code as a string from #generate" do
    # Arrange
    schema = {title: "Example", type: "object", definitions: {}}
    generator = JSONSchemaClassGenerator.new(schema)

    # Act
    result = generator.generate

    # Assert
    value(result).must_be_kind_of String
  end

  it "creates a Data.define class for each definition in the schema" do
    # Arrange
    dap_schema = JSON.load_file(TestHelper.path_relative_from_project_root("vendor/debug-adapter-protocol/debugAdapterProtocol.json"), symbolize_names: true)
    generator = JSONSchemaClassGenerator.new(dap_schema)

    # Act
    code = generator.generate

    # Assert
    value(code).must_match(/ProtocolMessage\s*=\s*Data\.define/)
  end

  it "includes all properties from the schema as snake_case attributes in the generated class" do
    # Arrange
    schema = TestHelper.deep_symbolize_keys({
      definitions: {
        Example: {
          type: "object",
          properties: {
            "camelCaseProperty" => {type: "string"},
            "anotherProperty" => {type: "integer"}
          }
        }
      }
    })
    generator = JSONSchemaClassGenerator.new(schema)

    # Act
    code = generator.generate

    # Assert
    value(code).must_match(/Example\s*=\s*Data\.define\(:camel_case_property, :another_property\)/)
  end

  it "converts consecutive capital letters in property names to snake_case correctly (e.g., JSONValue -> :json_value)" do
    # Arrange
    schema = TestHelper.deep_symbolize_keys({
      definitions: {
        Example: {
          type: "object",
          properties: {
            "JSONValue" => {type: "string"},
            "HTTPRequest" => {type: "string"}
          }
        }
      }
    })
    generator = JSONSchemaClassGenerator.new(schema)

    # Act
    code = generator.generate

    # Assert
    value(code).must_match(/Example\s*=\s*Data\.define\(:json_value, :http_request\)/)
  end

  it "only needs to handle the schema at vendor/debug-adapter-protocol/debugAdapterProtocol.json" do
    # Arrange
    dap_schema = JSON.load_file(TestHelper.path_relative_from_project_root("vendor/debug-adapter-protocol/debugAdapterProtocol.json"), symbolize_names: true)
    generator = JSONSchemaClassGenerator.new(dap_schema)

    # Act
    code = generator.generate

    # Assert
    value(code).must_be_kind_of String
  end
end
