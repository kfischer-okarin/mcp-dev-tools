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
        class_schema = merge_all_of(class_schema["allOf"]) if class_schema.key?("allOf")

        add_class(class_name, class_schema)
        add_line if index < @schema["definitions"].size - 1
      end
      @generated = true
    end

    @result
  end

  private

  def merge_all_of(sub_schemas)
    result = {
      "properties" => {}
    }
    sub_schemas.each do |sub_schema|
      if sub_schema.key?("$ref")
        sub_schema_class_name = sub_schema["$ref"].split("/").last
        sub_schema = @schema["definitions"][sub_schema_class_name]
      end

      if sub_schema.key?("properties")
        result["properties"].merge!(sub_schema["properties"])
        result["description"] = sub_schema["description"]
      end
    end
    result
  end

  def add_class(class_name, class_schema)
    add_class_comment(class_schema)
    properties = (class_schema["properties"] || {}).keys
    define_args = properties.map { |prop| ":#{to_snake_case(prop)}" }.join(", ")
    define_call_signature = define_args.empty? ? "" : "(#{define_args})"
    add_line "#{class_name} = Data.define#{define_call_signature}"
  rescue => e
    # Re-raise the exception with the class name for better debugging
    raise e.class, "#{class_name}: #{e.message}"
  end

  def to_snake_case(str)
    str.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2') # HTTPRequest -> HTTP_Request
      .gsub(/([a-z\d])([A-Z])/, '\1_\2') # camelCase -> camel_Case
      .downcase
  end

  def add_class_comment(class_schema)
    return unless class_schema["description"]

    description_lines = class_schema["description"].split("\n")
    description_lines.each do |line|
      add_line "# #{line}".strip
    end
  end

  def add_line(line = "")
    @result << line << "\n"
  end
end
