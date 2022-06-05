# frozen_string_literal: true

require_relative "./spec_helper"
require_relative "../lib/ar2dto/base"

RSpec.describe AR2DTO::Base do
  class User < ActiveRecord::Base
    include AR2DTO::Base
  end

  it "creates a new DTO class" do
    expect(Object.const_defined?("UserDTO")).to be true
  end
end
