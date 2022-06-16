# frozen_string_literal: true

require "active_model/lint"
require "minitest"

RSpec.shared_examples_for "ActiveModel" do
  include ActiveModel::Lint::Tests
  include Minitest::Assertions

  alias_method :model, :subject

  attr_accessor :assertions

  before(:each) { self.assertions = 0 }

  ActiveModel::Lint::Tests.public_instance_methods.map(&:to_s).grep(/^test/).each do |m|
    next if m == "test_to_key"

    it(m.sub("test_", "responds to ")) { send m }
  end
end
