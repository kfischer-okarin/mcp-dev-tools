class JsonSchemaClassGenerator
  def initialize(schema)
    @schema = schema
  end

  def generate
    result = ""
    @schema["definitions"].each do |class_name, class_schema|
      properties = class_schema["properties"].keys
      define_args = properties.map { |prop| ":#{prop}" }.join(", ")
      result << "#{class_name} = Data.define(#{define_args})\n"
    end
    result
  end
end
