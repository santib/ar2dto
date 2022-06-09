# frozen_string_literal: true

require "active_record"
require "active_model"
require_relative "ar2dto/active_model"
require_relative "ar2dto/dto"
require_relative "ar2dto/has_dto"
require_relative "ar2dto/version"

ActiveRecord::Base.include AR2DTO::HasDTO

module AR2DTO
  class Error < StandardError; end
  # Your code goes here...
end
