# frozen_string_literal: true

require_relative "./spec_helper"
require_relative "../lib/ar2dto/base"

RSpec.describe AR2DTO::Base do
  class User < ActiveRecord::Base
    include AR2DTO::Base
  end

  it "creates a new DTO class" do
    expect(Object.const_defined?("UserDTO")).to be true
  end

  describe "#to_dto" do
    subject { User.new(attributes).to_dto }

    let(:attributes) do
      {
        name: "Sandy",
        email: "sandy@example.com",
        birthday: Time.new(1995, 8, 25)
      }
    end

    it { is_expected.to be_a(UserDTO) }

    it "doesn't expose ActiveRecord's methods" do
      expect(subject).not_to respond_to(:update)
    end

    it "exposes methods to access the columns" do
      expect(subject).to have_attributes(attributes)
    end

    it "is equal to another DTO of the same class with the same attributes" do
      expect(subject).to eq(User.new(attributes).to_dto)
    end

    it "is not equal to another DTO of another class" do
      admin = double("Admin", attributes)

      expect(subject).not_to eq(admin)
    end

    it "is not equal to another DTO of the same class with different attributes" do
      other_user = User.new(attributes.merge(name: "Kent")).to_dto

      expect(subject).not_to eq(other_user)
    end

    it "exposes the attributes" do
      expect(subject.attributes).to include(
        attributes.stringify_keys.merge(
          "id" => nil,
          "updated_at" => nil
        )
      )
    end
  end
end
