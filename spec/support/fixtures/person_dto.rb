# frozen_string_literal: true

class PersonDTO
  attr_reader :attributes

  def initialize(attributes = {})
    @attributes = attributes
  end
end
