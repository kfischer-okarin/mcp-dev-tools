# frozen_string_literal: true

# SUMMARY: class JSONSchemaClassGenerator
# SUMMARY: This class generates Data classes from a JSON schema.
# SUMMARY: It is used to create classes for the Debug Adapter Protocol (DAP).
# <spec>
# - It takes a JSON schema as loaded via `JSON.load_file` with symbol keys as a single constructor argument.
# </spec>

class JSONSchemaClassGenerator
  def initialize(schema)
    @schema = schema
  end
end