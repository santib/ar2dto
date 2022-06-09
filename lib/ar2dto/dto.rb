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
    include AR2DTO::ActiveModel

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
  end
end
