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

    def ==(other)
      if other.instance_of?(self.class)
        as_json == other.as_json
      else
        super
      end
    end
  end
end
