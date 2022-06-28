# frozen_string_literal: true

require "singleton"

module AR2DTO
  class Config
    include Singleton

    def self.reset!
      instance.active_model_compliance = true
      instance.except = []
      instance.replace_suffix = { from: "", to: "DTO" }
    end

    attr_accessor :except, :replace_suffix, :active_model_compliance

    def initialize
      @active_model_compliance = true
      @except = []
      @replace_suffix = { from: "", to: "DTO" }
    end
  end
end
