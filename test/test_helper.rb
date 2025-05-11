# frozen_string_literal: true

require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

module TestHelper
  class << self
    def path_relative_from_project_root(relative_path)
      File.expand_path(File.join(__dir__, "..", relative_path))
    end

    def deep_symbolize_keys(obj)
      case obj
      when Hash
        obj.each_with_object({}) do |(k, v), acc|
          acc[k.to_sym] = deep_symbolize_keys(v)
        end
      when Array
        obj.map { |e| deep_symbolize_keys(e) }
      else
        obj
      end
    end
  end
end
