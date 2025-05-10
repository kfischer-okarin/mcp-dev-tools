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
          "properties" => {
            "seq" => {},
            "type" => {}
          }
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
        "NoProperties" => {}
      }
    }

    result = JsonSchemaClassGenerator.new(schema).generate

    refute_includes result, "NoProperties"
  end

  def test_class_definitions_are_separated_by_newlines
    schema = {
      "definitions" => {
        "Foo" => {"properties" => {}},
        "Bar" => {"properties" => {}}
      }
    }

    result = JsonSchemaClassGenerator.new(schema).generate

    expected = <<~RUBY.strip
      Foo = Data.define()

      Bar = Data.define()
    RUBY
    assert_includes result, expected
    assert_operator result, :end_with?, ")\n", "Expected no additional newline at the end"
  end

  def test_description_is_added_as_class_comment
    schema = {
      "definitions" => {
        "Foo" => {
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
