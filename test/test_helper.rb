# frozen_string_literal: true

require "minitest/autorun"
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

module TestHelper
  def self.path_relative_from_project_root(relative_path)
    File.expand_path(File.join(__dir__, "..", relative_path))
  end
end
