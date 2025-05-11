# frozen_string_literal: true

require 'json'
require_relative 'test_helper'
require_relative '../lib/json_schema_class_generator'

class TestJSONSchemaClassGenerator < Minitest::Test
  def sample_schema
    {
      title: 'Example',
      type: 'object',
      properties: {
        foo: { type: 'string' },
        bar: { type: 'integer' }
      },
      required: %i[foo bar]
    }
  end

  def test_initialize_with_symbol_keys
    assert JSONSchemaClassGenerator.new(sample_schema)
  end
end
