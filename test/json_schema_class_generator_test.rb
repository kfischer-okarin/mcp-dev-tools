require_relative "test_helper"

require_relative "../lib/json_schema_class_generator"

describe JsonSchemaClassGenerator do
  specify "exception messages contain the definition name" do
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
    value(error.message).must_include "BadDefinition"
  end

  it "defines data class with properties" do
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

    value(result).must_include expected
  end

  it "skips definitions without properties" do
    schema = {
      "definitions" => {
        "NoProperties" => {}
      }
    }

    result = JsonSchemaClassGenerator.new(schema).generate

    value(result).wont_include "NoProperties"
  end

  it "separates class definitions by newlines" do
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
    value(result).must_include expected
    value(result).must_be :end_with?, ")\n", "Expected no additional newline at the end"
  end

  it "adds description as class comment" do
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

    value(result).must_include expected
  end
end
