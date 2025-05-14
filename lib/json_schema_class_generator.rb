# frozen_string_literal: true

class JSONSchemaClassGenerator
  def initialize(schema)
    @schema = schema
  end

  def generate
    return "" unless @schema.is_a?(Hash) && @schema[:definitions].is_a?(Hash)
    definitions = @schema[:definitions]
    definitions.map do |name, definition|
      all_props = collect_all_properties(definition, definitions)
      next if all_props.empty?
      attrs = all_props.keys.map { |k| camel_to_snake(k).to_sym }
      "#{name} = Data.define(#{attrs.map { |a| ":#{a}" }.join(", ")})"
    end.compact.join("\n")
  end

  private

  # Recursively collects all properties for a definition, including allOf references, preserving order and not overwriting existing keys
  def collect_all_properties(definition, definitions)
    props = {}
    if definition[:allOf].is_a?(Array)
      definition[:allOf].each do |item|
        ref_val = item["$ref"] || item[:$ref] if item.is_a?(Hash)
        if item.is_a?(Hash) && ref_val
          ref = ref_val
          if ref =~ %r{^#/definitions/(.+)$}
            ref_name = Regexp.last_match(1).to_sym
            ref_def = definitions[ref_name]
            if ref_def
              collect_all_properties(ref_def, definitions).each do |k, v|
                props[k] = v unless props.key?(k)
              end
            end
          end
        elsif item.is_a?(Hash)
          collect_all_properties(item, definitions).each do |k, v|
            props[k] = v unless props.key?(k)
          end
        end
      end
    end
    if definition[:properties].is_a?(Hash)
      definition[:properties].each do |k, v|
        props[k] = v unless props.key?(k)
      end
    end
    props
  end

  # Converts CamelCase or PascalCase to snake_case, handling consecutive capitals correctly
  def camel_to_snake(str)
    str
      .to_s
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2') # handle consecutive capitals again
      .downcase
  end
end
