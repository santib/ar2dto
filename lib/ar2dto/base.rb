# frozen_string_literal: true

module AR2DTO
  module Base
    def self.included(model)
      namespace = model.name.deconstantize.presence&.constantize || Object

      namespace.const_set("#{model.name.split("::").last}DTO", Class.new do
        include ::ActiveModel::Model
        attr_reader :attributes
        attr_accessor(*model.column_names)

        def initialize(attributes)
          @attributes = attributes
          super
        end

        def ==(other)
          attributes == other.attributes
        end
      end)
    end

    def to_dto
      "#{self.class.name}DTO".constantize.new(attributes)
    end
  end
end
