# frozen_string_literal: true

module AR2DTO
  module DTO
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
