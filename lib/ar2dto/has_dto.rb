# frozen_string_literal: true

module AR2DTO
  # Extensions to `ActiveRecord::Base`.
  module HasDTO
    def self.included(base)
      base.extend ::AR2DTO::HasDTO::ClassMethods
    end

    module ClassMethods
      # Declare this in your model to expose the DTO helpers.
      #
      # @api public
      def has_dto
        include ::AR2DTO::HasDTO::InstanceMethods
        namespace = name.deconstantize.presence&.constantize || Object
        class_name = "#{name.split("::").last}DTO"

        return if namespace.const_defined?(class_name)

        namespace.const_set(class_name, AR2DTO::DTO[self])
      end

      # @api public
      def to_dto
        all.map(&:to_dto)
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
