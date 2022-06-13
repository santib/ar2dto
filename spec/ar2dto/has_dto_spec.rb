# frozen_string_literal: true

require "spec_helper"

RSpec.describe ".has_dto" do
  it "creates a new DTO class" do
    expect(Object.const_defined?("UserDTO")).to be true
  end

  describe "#to_dto" do
    subject { user.to_dto }

    let(:attributes) do
      {
        name: "Sandy",
        email: "sandy@example.com",
        birthday: Time.new(1995, 8, 25)
      }
    end

    context "when active record is in memory" do
      let(:user) { User.new(attributes) }

      it { is_expected.to be_a(UserDTO) }

      it "doesn't expose ActiveRecord's methods" do
        expect(subject).not_to respond_to(:update)
      end

      it "exposes methods to access the columns" do
        expect(subject).to have_attributes(attributes)
      end

      it "exposes methods to access the columns set by persistance" do
        expect(subject).to have_attributes(
          id: nil,
          created_at: nil,
          updated_at: nil
        )
      end

      it "is equal to another DTO of the same class with the same attributes that is in memory" do
        user_with_same_attributes = User.new(attributes)

        expect(subject).to eq(user_with_same_attributes.to_dto)
      end

      it "is not equal to another DTO of another class with same attributes" do
        admin = double("Admin", attributes)

        expect(subject).not_to eq(admin)
      end

      it "is not equal to another DTO of the same class with different attributes" do
        other_user = User.new(attributes.merge(name: "Kent")).to_dto

        expect(subject).not_to eq(other_user)
      end

      it "is not possible to set values from outside" do
        expect { subject.name = "Martin" }.to raise_error(NoMethodError)
      end
    end

    context "when active record is persisted" do
      let(:user) { User.create(attributes) }

      it { is_expected.to be_a(UserDTO) }

      it "doesn't expose ActiveRecord's methods" do
        expect(subject).not_to respond_to(:update)
      end

      it "exposes methods to access the columns" do
        expect(subject).to have_attributes(attributes)
      end

      it "exposes methods to access the columns set by persistance" do
        expect(subject).to have_attributes(
          id: user.id,
          created_at: user.created_at,
          updated_at: user.updated_at
        )
      end

      it "is not equal to another DTO of the same class with the same attributes that is persisted" do
        user_with_same_attributes = User.create(attributes)

        expect(subject).not_to eq(user_with_same_attributes.to_dto)
      end

      it "is not equal to another DTO of another class with same attributes" do
        admin = double("Admin", user.attributes)

        expect(subject).not_to eq(admin)
      end

      it "is not possible to set values from outside" do
        expect { subject.name = "Martin" }.to raise_error(NoMethodError)
      end
    end
  end
end
