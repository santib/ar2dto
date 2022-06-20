# frozen_string_literal: true

class PersonDTO
  attr_reader :attributes

  def initialize(attributes = {})
    @attributes = attributes
  end

  def user_id
    attributes["user_id"]
  end
end
