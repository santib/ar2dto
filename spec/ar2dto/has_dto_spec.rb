# frozen_string_literal: true

RSpec.describe ".has_dto" do
  it "creates a new DTO class" do
    expect(Object.const_defined?("UserDTO")).to be true

    expect(UserDTO.superclass).to eq AR2DTO::DTO
  end

  it "creates the new DTO class in the correct namespace" do
    expect(Shop.const_defined?("OrderDTO")).to be true
  end

  context "when the class already exists" do
    it "does not create a new class" do
      expect(Object.const_defined?("PersonDTO")).to be true

      expect(PersonDTO.superclass).to_not eq AR2DTO::DTO
    end
  end
end
