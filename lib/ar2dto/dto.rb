# frozen_string_literal: true

module AR2DTO
  class DTO
    class << self
      def [](original_model)
        Class.new(self) do
          attr_accessor(*original_model.attribute_names)

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
      attributes.each { |key, value| send("#{key}=", value) }

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
