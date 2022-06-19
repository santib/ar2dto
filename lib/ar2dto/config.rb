# frozen_string_literal: true

require "singleton"

module AR2DTO
  class Config
    include Singleton

    def self.reset!
      instance.except = []
    end

    attr_accessor :except

    def initialize
      @except = []
    end
  end
end
