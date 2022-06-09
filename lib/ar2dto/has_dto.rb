# frozen_string_literal: true

module AR2DTO
  # Extensions to `ActiveRecord::Base`.
  module HasDTO
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

        namespace.const_set("#{model.name.split("::").last}DTO", AR2DTO::DTO[model])

        model.include HasDTO::InstanceMethods
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
