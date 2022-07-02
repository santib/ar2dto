# frozen_string_literal: true

module AR2DTO
  class DTO
    def self.[](original_model)
      Class.new(self) do
        include ::AR2DTO::ActiveModel if original_model.ar2dto.active_model_compliance
        define_singleton_method(:original_model) { original_model }
      end
    end

    def initialize(attributes = {})
      attributes.each { |key, value| define_singleton_method(key) { value } }
      super()
    end

    def ==(other)
      if other.instance_of?(self.class)
        attribute_names = self.class.original_model.attribute_names
        attribute_names.all? { |name| send(name) == other.send(name) }
      else
        super
      end
    end
  end
end
