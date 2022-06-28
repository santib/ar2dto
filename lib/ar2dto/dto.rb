# frozen_string_literal: true

module AR2DTO
  class DTO
    class << self
      def [](original_model)
        Class.new(self) do
          define_singleton_method :original_model do
            original_model
          end
        end
      end
    end

    def self.inherited(base)
      base.include ::AR2DTO::ActiveModel if ::AR2DTO::Config.instance.active_model_compliance
      super
    end

    def initialize(attributes = {})
      singleton_class.instance_eval { attr_reader(*attributes.keys) }

      attributes.each { |key, value| instance_variable_set("@#{key}", value) }

      super()
    end

    def ==(other)
      if other.instance_of?(self.class)
        attribute_names = self.class.original_model.attribute_names
        as_json(only: attribute_names) == other.as_json(only: attribute_names)
      else
        super
      end
    end
  end
end
