# frozen_string_literal: true

require_relative "dto"

module AR2DTO
  module Base
    def self.included(model)
      namespace = model.name.deconstantize.presence&.constantize || Object

      namespace.const_set("#{model.name.split("::").last}DTO", Class.new do
        include ::ActiveModel::Model
        include AR2DTO::DTO
        attr_reader :attributes
        attr_accessor(*model.column_names)
      end)
    end

    def to_dto
      "#{self.class.name}DTO".constantize.new(attributes)
    end
  end
end
