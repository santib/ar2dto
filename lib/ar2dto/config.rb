# frozen_string_literal: true

module AR2DTO
  class Config
    include Singleton

    def self.reset!
      instance.active_model_compliance = true
      instance.except = []
      instance.delete_suffix = nil
      instance.add_suffix = "DTO"
    end

    attr_accessor :active_model_compliance, :except, :delete_suffix, :add_suffix

    def initialize
      @active_model_compliance = true
      @except = []
      @delete_suffix = nil
      @add_suffix = "DTO"
    end
  end
end
