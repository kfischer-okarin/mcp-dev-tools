require_relative "test_helper"

require_relative "../lib/json_schema_class_generator"

class JsonSchemaClassGeneratorTest < Minitest::Test
  def test_exception_includes_definition_name
    schema = {
      "definitions" => {
        "BadDefinition" => {
          "properties" => {}
        }
      }
    }
    schema["definitions"]["BadDefinition"].define_singleton_method(:[]) do |_|
      raise StandardError, "This is a test error"
    end

    error = assert_raises(StandardError) do
      JsonSchemaClassGenerator.new(schema).generate
    end
    assert_includes error.message, "BadDefinition"
  end

  def test_defines_data_class_with_properties
    schema = {
      "definitions" => {
        "ProtocolMessage" => {
          "type" => "object",
          "properties" => {
            "seq" => {},
            "type" => {}
          },
          "required" => ["seq", "type"]
        }
      }
    }

    result = JsonSchemaClassGenerator.new(schema).generate

    expected = <<~RUBY.strip
      ProtocolMessage = Data.define(:seq, :type)
    RUBY

    assert_includes result, expected
  end

  def test_skips_definitions_without_properties
    schema = {
      "definitions" => {
        "NoProperties" => {
          "type" => "object"
        }
      }
    }

    result = JsonSchemaClassGenerator.new(schema).generate

    refute_includes result, "NoProperties"
  end

  def test_description_is_added_as_class_comment
    schema = {
      "definitions" => {
        "Foo" => {
          "type" => "object",
          "description" => "A foo object.\n\nYou can use it for bar.",
          "properties" => {
            "bar" => {}
          }
        }
      }
    }

    result = JsonSchemaClassGenerator.new(schema).generate

    expected = <<~RUBY.strip
      # A foo object.
      #
      # You can use it for bar.
      Foo = Data.define
    RUBY

    assert_includes result, expected
  end
end
