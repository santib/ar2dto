# frozen_string_literal: true

require "active_record"
require "active_model"

require_relative "ar2dto/active_model"
require_relative "ar2dto/dto"
require_relative "ar2dto/config"
require_relative "ar2dto/converter"
require_relative "ar2dto/version"
require_relative "ar2dto/has_dto"

ActiveRecord::Base.include ::AR2DTO::HasDTO

module AR2DTO
  class Error < StandardError; end

  def self.configure
    @config ||= AR2DTO::Config.instance
    yield @config if block_given?
    @config
  end
end
