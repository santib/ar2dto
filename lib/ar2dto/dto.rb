# frozen_string_literal: true

module AR2DTO
  module DTO
    def self.included(base)
      base.include ::ActiveModel::Model
      base.class_eval do
        attr_reader :attributes
        attr_accessor(*base::ATTR_NAMES)

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
  end
end
