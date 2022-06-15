# frozen_string_literal: true

require_relative "./spec_helper"
require_relative "../lib/ar2dto"

RSpec.describe ".has_dto" do
  it "creates a new DTO class" do
    expect(Object.const_defined?("UserDTO")).to be true
  end

  it "creates the new DTO class in the correct namespace" do
    expect(Shop.const_defined?("OrderDTO")).to be true
  end

  describe "#to_dto" do
    context "when active record is in memory" do
      let(:attributes) do
        {
          name: "Sandy",
          email: "sandy@example.com",
          birthday: Time.new(1995, 8, 25)
        }
      end

      subject { user.to_dto }

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
    end

    context "when active record is persisted" do
      let(:attributes) do
        {
          name: "Sandy",
          email: "sandy@example.com",
          birthday: Time.new(1995, 8, 25)
        }
      end

      subject { user.to_dto }

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
    end

    context "with a namespaced model" do
      let(:attributes) do
        {
          user_id: 1
        }
      end

      subject { order.to_dto }

      let(:order) { Shop::Order.new(attributes) }

      it { is_expected.to be_a(Shop::OrderDTO) }
    end
  end

  describe ".to_dto" do
    subject { relation.to_dto }

    let(:relation) { User.all }

    before do
      User.create!(name: "Sandy", email: "sandy@example.com")
      User.create!(name: "Kent", email: "kent@example.com")
      User.create!(name: "Martin", email: "martin@example.com")
    end

    it "returns an array of DTOs" do
      expect(subject).to be_an(Array)
      expect(subject.size).to eq(3)
      expect(subject.first).to be_a(UserDTO)
      expect(subject.second).to be_a(UserDTO)
      expect(subject.third).to be_a(UserDTO)
    end

    context "when the relation is scoped" do
      let(:relation) { User.where(name: "Sandy") }

      it "returns the DTO of the matching records" do
        expect(subject).to be_an(Array)
        expect(subject.size).to eq(1)
        expect(subject.first).to be_a(UserDTO)
        expect(subject.first.name).to eq("Sandy")
      end
    end
  end
end
