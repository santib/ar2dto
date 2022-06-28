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
      def has_dto(options = {})
        include ::AR2DTO::HasDTO::InstanceMethods
        ar2dto.setup_config(options)

        begin
          ar2dto.namespaced_class_name.constantize
        rescue NameError
          ar2dto.namespace.const_set(ar2dto.class_name, AR2DTO::DTO[self])
        end
      end

      # @api public
      def to_dto(options = {})
        all.map { |record| record.to_dto(options) }
      end

      # @api public
      def ar2dto
        @ar2dto ||= AR2DTO::ModelConfig.new(self)
      end
    end

    # Wrap the following methods in a module so we can include them only in the
    # ActiveRecord models that declare `has_dto`.
    module InstanceMethods
      # @api public
      def to_dto(options = {})
        self.class.ar2dto.namespaced_class_name.constantize.new(
          AR2DTO::Converter.new(self, options).serializable_hash
        )
      end
    end
  end
end
