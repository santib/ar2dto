# frozen_string_literal: true

require_relative "ar2dto/version"
require_relative "ar2dto/has_dto"

ActiveRecord::Base.include AR2DTO::Model

module AR2DTO
  class Error < StandardError; end
  # Your code goes here...
end
