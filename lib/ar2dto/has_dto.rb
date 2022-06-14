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
        include Model::InstanceMethods
        namespace = name.deconstantize.presence&.constantize || Object
        class_name = "#{name.split("::").last}DTO"

        return if namespace.const_defined?(class_name)

        namespace.const_set(class_name, AR2DTO::DTO[self])
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
