# frozen_string_literal: true

# SUMMARY: class JSONSchemaClassGenerator
# SUMMARY: This class generates Data classes from a JSON schema.
# SUMMARY: It is used to create classes for the Debug Adapter Protocol (DAP).
# <spec>
# - It takes a JSON schema as loaded via `JSON.load_file` with symbol keys as a single constructor argument.
# - Generation will be done via a `generate` instance method which should return the generated Ruby code as a string.
# - It only needs to be able to handle the schema at vendor/debug-adapter-protocol/debugAdapterProtocol.json
# - It should create a value object class using `Data.define` for each definition in the schema.
# </spec>

class JSONSchemaClassGenerator
  def initialize(schema)
    @schema = schema
  end

  def generate
    return '' unless @schema.is_a?(Hash) && @schema[:definitions].is_a?(Hash)
    @schema[:definitions].map do |name, _def|
      "#{name} = Data.define"
    end.join("\n")
  end
end