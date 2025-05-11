# frozen_string_literal: true

class JSONSchemaClassGenerator
  def initialize(schema)
    @schema = schema
  end

  def generate
    return "" unless @schema.is_a?(Hash) && @schema[:definitions].is_a?(Hash)
    @schema[:definitions].map do |name, definition|
      next unless definition.is_a?(Hash) && definition[:properties].is_a?(Hash)
      attrs = definition[:properties].keys.map { |k| camel_to_snake(k).to_sym }
      "#{name} = Data.define(#{attrs.map { |a| ":#{a}" }.join(', ')})"
    end.compact.join("\n")
  end

  private

  # Converts CamelCase or PascalCase to snake_case, handling consecutive capitals correctly
  def camel_to_snake(str)
    str
      .to_s
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .downcase
  end
end
