# frozen_string_literal: true

# Extracted from:
# https://github.com/paper-trail-gem/paper_trail/blob/49659e8a0c4cb0c80aeab344b7b434de7f057c88/lib/paper_trail/has_paper_trail.rb

require_relative "dto"

module AR2DTO
  # Extensions to `ActiveRecord::Base`.
  module Model
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      # Declare this in your model to expose the DTO helpers.
      #
      # @api public
      def has_dto
        model = self
        namespace = model.name.deconstantize.presence&.constantize || Object

        namespace.const_set("#{model.name.split("::").last}DTO", Class.new do
          include ::ActiveModel::Model
          include AR2DTO::DTO
          attr_reader :attributes
          attr_accessor(*model.column_names)
        end)

        model.include Model::InstanceMethods
      end
    end

    # Wrap the following methods in a module so we can include them only in the
    # ActiveRecord models that declare `has_dto`.
    module InstanceMethods
      # @api public
      def to_dto
        "#{self.class.name}DTO".constantize.new(attributes)
      end
    end
  end
end
