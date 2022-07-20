# frozen_string_literal: true

module AR2DTO
  class DTO
    def self.[](original_model)
      Class.new(self) do
        include ::AR2DTO::ActiveModel if original_model.ar2dto.active_model_compliance
        define_singleton_method(:original_model) { original_model }
        attr_reader(*original_model.attribute_names)
      end
    end

    def initialize(data = {})
      attribute_names = self.class.original_model.attribute_names

      data.each do |key, value|
        if attribute_names.include?(key)
          instance_variable_set("@#{key}", value)
        else
          define_singleton_method(key) { value }
        end
      end

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
