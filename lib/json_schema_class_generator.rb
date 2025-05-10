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
        next unless class_schema.key?("properties") # TODO: Handle allOf

        properties = class_schema["properties"].keys
        define_args = properties.map { |prop| ":#{prop}" }.join(", ")
        if class_schema["description"]
          description_lines = class_schema["description"].split("\n")
          description_lines.each do |line|
            @result << "# #{line}".strip << "\n"
          end
        end
        @result << "#{class_name} = Data.define(#{define_args})\n"
        @result << "\n" if index < @schema["definitions"].size - 1
      rescue => e
        # Re-raise the exception with the class name for better debugging
        raise e.class, "#{class_name}: #{e.message}"
      end
      @generated = true
    end

    @result
  end
end
