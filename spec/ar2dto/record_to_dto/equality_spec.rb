# frozen_string_literal: true

RSpec.describe "#to_dto" do
  describe "equality" do
    let(:attributes) do
      {
        first_name: "Sandy",
        last_name: "Doe",
        email: "sandy@example.com",
        birthday: Time.new(1995, 8, 25)
      }
    end
    let(:options) { {} }

    subject { user.to_dto(options) }

    context "when active record is in memory" do
      let(:user) { User.new(attributes) }

      it "is equal to another DTO of the same class with the same attributes" do
        user_with_same_attributes = User.new(attributes)

        expect(subject).to eq(user_with_same_attributes.to_dto)
      end

      it "is not equal to another DTO of another class with same attributes" do
        admin = double("Admin", attributes)

        expect(subject).not_to eq(admin)
      end

      it "is not equal to another DTO of the same class with different attributes" do
        other_user = User.new(attributes.merge(first_name: "Kent")).to_dto

        expect(subject).not_to eq(other_user)
      end

      context "when including associations" do
        let(:options) do
          { include: %i[orders person] }
        end

        before do
          user.orders.new
          user.build_person
        end

        it "is equal to another DTO of the same class with different data for associations" do
          user_with_same_attributes = User.new(attributes)

          expect(subject).to eq(user_with_same_attributes.to_dto)
        end
      end
    end

    context "when active record is persisted" do
      let(:user) { User.create!(attributes) }

      it "is not equal to another DTO of the same class with the same attributes that is persisted" do
        user_with_same_attributes = User.create!(attributes)

        expect(subject).not_to eq(user_with_same_attributes.to_dto)
      end

      it "is not equal to another DTO of another class with same attributes" do
        admin = double("Admin", user.attributes)

        expect(subject).not_to eq(admin)
      end

      context "when including associations" do
        let(:options) do
          { include: %i[orders person] }
        end

        before do
          user.orders.create!
          user.create_person!
        end

        it "is equal to another DTO of the same class with different data for associations" do
          expect(subject).to eq(user.to_dto)
        end
      end
    end
  end
end
