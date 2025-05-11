# frozen_string_literal: true

class JSONSchemaClassGenerator
  def initialize(schema)
    @schema = schema
  end

  def generate
    return "" unless @schema.is_a?(Hash) && @schema[:definitions].is_a?(Hash)
    @schema[:definitions].map do |name, _def|
      "#{name} = Data.define"
    end.join("\n")
  end
end
