# frozen_string_literal: true

require "singleton"

module AR2DTO
  class Config
    include Singleton

    def self.reset!
      instance.except = []
      instance.class_prefix = ""
      instance.class_suffix = "DTO"
    end

    attr_accessor :except, :class_prefix, :class_suffix

    def initialize
      @except = []
      @class_prefix = ""
      @class_suffix = "DTO"
    end
  end
end
