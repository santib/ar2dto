# frozen_string_literal: true

module AR2DTO
  class DTO
    class << self
      def [](original_model)
        Class.new(self) do
          define_singleton_method :public_attributes do
            original_model.attribute_names.map(&:to_sym) -
              AR2DTO::Config.instance.except
          end

          attr_reader(*public_attributes)

          private

          attr_writer(*public_attributes)

          define_singleton_method :original_model do
            original_model
          end
        end
      end
    end

    def self.inherited(base)
      base.include ::AR2DTO::ActiveModel
      super
    end

    def initialize(attributes = {})
      self.class.public_attributes.map(&:to_s).each { |key, _value| send("#{key}=", attributes[key]) }

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
