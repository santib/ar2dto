# frozen_string_literal: true

require "singleton"

module AR2DTO
  class Config
    include Singleton

    def self.reset!
      instance.except = []
      instance.replace_suffix = { from: "", to: "DTO" }
    end

    attr_accessor :except, :replace_suffix

    def initialize
      @except = []
      @replace_suffix = { from: "", to: "DTO" }
    end
  end
end
