# frozen_string_literal: true

module AR2DTO
  class DTO
    def self.[](original_model)
      Class.new(self) do
        include ::AR2DTO::ActiveModel if original_model.ar2dto.active_model_compliance
        define_singleton_method(:original_model) { original_model }
      end
    end

    def initialize(data = {})
      @data = data.symbolize_keys
      super()
    end

    def as_json(options = nil)
      attribute_names = self.class.original_model.attribute_names.map(&:to_sym)
      @data.slice(*attribute_names).as_json(options)
    end

    def ==(other)
      if other.instance_of?(self.class)
        as_json == other.as_json
      else
        super
      end
    end

    def respond_to_missing?(name, include_private = false)
      @data.key?(name) || super
    end

    def method_missing(method, *args, &block)
      return @data[method] if @data.key?(method)

      super
    end
  end
end
