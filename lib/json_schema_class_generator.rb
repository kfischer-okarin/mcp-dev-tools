# frozen_string_literal: true

class JSONSchemaClassGenerator
  def initialize(schema)
    @schema = schema
  end

  def generate
    return "" unless @schema.is_a?(Hash) && @schema[:definitions].is_a?(Hash)
    @schema[:definitions].map do |name, definition|
      next unless definition.is_a?(Hash) && definition[:properties].is_a?(Hash)
      attrs = definition[:properties].keys.map { |k| k.to_s.gsub(/([A-Z])/, '_\\1').downcase.sub(/^_/, '').to_sym }
      "#{name} = Data.define(#{attrs.map { |a| ":#{a}" }.join(', ')})"
    end.compact.join("\n")
  end
end
