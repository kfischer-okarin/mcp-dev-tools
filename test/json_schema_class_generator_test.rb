require_relative "test_helper"

require_relative "../lib/json_schema_class_generator"

module JsonSchemaClassGeneratorAssertions
  refine Minitest::Expectation do
    def must_include_consecutive_lines(*expected_lines)
      actual_lines = target.split("\n")
      start_line_index = 0
      matched = false
      while start_line_index + expected_lines.size <= actual_lines.size
        actual_lines_to_match = actual_lines[start_line_index, expected_lines.size]
        if expected_lines == actual_lines_to_match
          matched = true
          break
        end

        start_line_index += 1
      end

      error = <<~ERROR
        Expected:
        ---
        #{target}
        ---
        to include consecutive lines:
        ---
        #{expected_lines.join("\n")}

        ---
        But it did not.
      ERROR
      ctx.assert matched, error
    end
  end

  LineStartingWith = Data.define(:prefix) do
    def ==(other)
      other.is_a?(String) && other.start_with?(prefix)
    end

    def to_s
      "<Line starting with #{prefix.inspect}>"
    end
  end

  refine Minitest::Spec do
    def line_starting_with(prefix)
      LineStartingWith.new(prefix)
    end
  end
end

describe JsonSchemaClassGenerator do
  using JsonSchemaClassGeneratorAssertions

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

    value(result).must_include_consecutive_lines(
      line_starting_with("ProtocolMessage = Data.define")
    )
  end

  it "handles definitions without properties" do
    schema = {
      "definitions" => {
        "NoProperties" => {}
      }
    }

    result = JsonSchemaClassGenerator.new(schema).generate

    value(result).must_include_consecutive_lines(
      "NoProperties = Data.define"
    )
  end

  it "separates class definitions by newlines" do
    schema = {
      "definitions" => {
        "Foo" => {"properties" => {}},
        "Bar" => {"properties" => {}}
      }
    }

    result = JsonSchemaClassGenerator.new(schema).generate

    value(result).must_include_consecutive_lines(
      "Foo = Data.define",
      "",
      "Bar = Data.define"
    )
    value(result).must_be :end_with?, "define\n", "Expected no additional newline at the end"
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

    value(result).must_include_consecutive_lines(
      "# A foo object.",
      "#",
      "# You can use it for bar.",
      line_starting_with("Foo = Data.define")
    )
  end

  it "converts property names to snake_case in the generated data class" do
    schema = {
      "definitions" => {
        "CamelCaseProps" => {
          "properties" => {
            "camelCaseProp" => {},
            "anotherPropertyName" => {},
            "already_snake" => {}
          }
        }
      }
    }

    result = JsonSchemaClassGenerator.new(schema).generate

    value(result).must_include "CamelCaseProps = Data.define(:camel_case_prop, :another_property_name, :already_snake)"
  end
end
