# frozen_string_literal: true

module AR2DTO
  module ActiveModel
    def self.included(base)
      base.include ::ActiveModel::Conversion
      base.extend ::ActiveModel::Naming
      base.extend ::ActiveModel::Translation
      base.extend ::AR2DTO::ActiveModel::ClassMethods

      base.class_eval do
        def persisted?
          id.present?
        end

        def errors
          @errors ||= ::ActiveModel::Errors.new(self.class.original_model)
        end

        def to_partial_path
          self.class.original_model._to_partial_path
        end
      end
    end

    module ClassMethods
      def model_name
        ::ActiveModel::Name.new(original_model)
      end
    end
  end
end
