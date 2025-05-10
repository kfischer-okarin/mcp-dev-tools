# frozen_string_literal: true

class JsonSchemaClassGenerator
  def initialize(schema)
    @schema = schema
    @result = +""
    @generated = false
  end

  def generate
    unless @generated
      @schema["definitions"].each.with_index do |(class_name, class_schema), index|
        add_class(class_name, class_schema)
        add_line if index < @schema["definitions"].size - 1
      end
      @generated = true
    end

    @result
  end

  private

  def add_class(class_name, class_schema)
    return unless class_schema.key?("properties") # TODO: Handle allOf

    if class_schema["description"]
      description_lines = class_schema["description"].split("\n")
      description_lines.each do |line|
        add_line "# #{line}".strip
      end
    end
    properties = class_schema["properties"].keys
    define_args = properties.map { |prop| ":#{prop}" }.join(", ")
    add_line "#{class_name} = Data.define(#{define_args})"
  rescue => e
    # Re-raise the exception with the class name for better debugging
    raise e.class, "#{class_name}: #{e.message}"
  end

  def add_line(line = "")
    @result << line << "\n"
  end
end
