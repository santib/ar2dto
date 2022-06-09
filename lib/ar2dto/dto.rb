# frozen_string_literal: true

module AR2DTO
  class DTO
    class << self
      def [](original_model)
        Class.new(self) do |_klass|
          attr_accessor(*original_model.attribute_names)
        end
      end
    end

    include ::ActiveModel::Model
    attr_reader :attributes

    def initialize(attributes)
      @attributes = attributes
      super
    end

    def ==(other)
      if other.instance_of?(self.class)
        attributes == other.attributes
      else
        super
      end
    end
  end
end
