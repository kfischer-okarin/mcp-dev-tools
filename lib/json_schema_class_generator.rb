# frozen_string_literal: true

class JsonSchemaClassGenerator
  def initialize(schema)
    @schema = schema
  end

  def generate
    result = +""
    @schema["definitions"].each do |class_name, class_schema|
      next unless class_schema.key?("properties") # TODO: Handle allOf

      properties = class_schema["properties"].keys
      define_args = properties.map { |prop| ":#{prop}" }.join(", ")
      if class_schema["description"]
        description_lines = class_schema["description"].split("\n")
        description_lines.each do |line|
          result << "# #{line}".strip << "\n"
        end
      end
      result << "#{class_name} = Data.define(#{define_args})\n"
    rescue => e
      # Re-raise the exception with the class name for better debugging
      raise e.class, "#{class_name}: #{e.message}"
    end
    result
  end
end
