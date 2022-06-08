# frozen_string_literal: true

module AR2DTO
  class DTO
    class << self
      def [](original_model)
        Class.new(self) do |klass|
          klass.const_set(:ORIGINAL_MODEL, original_model)
          attr_accessor(*original_model.attribute_names)
        end
      end
    end

    include ::ActiveModel::AttributeAssignment
    include ::ActiveModel::Conversion
    extend ::ActiveModel::Naming
    extend ::ActiveModel::Translation

    def initialize(attributes = {})
      assign_attributes(attributes) if attributes

      super()
    end

    def ==(other)
      if other.instance_of?(self.class)
        as_json == other.as_json
      else
        super
      end
    end

    def persisted?
      !!id
    end

    def errors
      @errors ||= ::ActiveModel::Errors.new(self.class::ORIGINAL_MODEL)
    end

    def to_partial_path
      self.class::ORIGINAL_MODEL._to_partial_path
    end

    def self.model_name
      ActiveModel::Name.new(self::ORIGINAL_MODEL)
    end
  end
end
