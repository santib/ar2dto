# frozen_string_literal: true

RSpec.describe ".to_dto" do
  describe "associations" do
    let(:relation) { User.all }

    subject { relation.to_dto(options) }

    let!(:user) do
      User.create!(first_name: "Sandy", last_name: "Doe", email: "sandy@example.com")
    end
    let!(:another_user) do
      User.create!(first_name: "Kent", last_name: "Simpson", email: "kent@example.com")
    end

    before do
      user.orders.create!
      another_user.orders.create!
      user.create_person!
    end

    context "when including associations" do
      let(:options) do
        { include: %i[orders person] }
      end

      it "becomes accessible in the DTOs" do
        expect(subject.first.orders).to be_an(Array)
        expect(subject.first.orders.first).to be_an(Shop::OrderDTO)
        expect(subject.first.orders.first.user_id).to eq(user.id)
        expect(subject.first.orders.first.user_id).to_not be_nil
        expect(subject.first.person).to be_a(PersonDTO)
        expect(subject.first.person.user_id).to eq(user.id)
        expect(subject.second.orders).to be_an(Array)
        expect(subject.second.orders.first).to be_an(Shop::OrderDTO)
        expect(subject.second.orders.first.user_id).to eq(another_user.id)
        expect(subject.second.orders.first.user_id).to_not be_nil
        expect(subject.second.person).to be_nil
      end
    end

    context "when not including associations" do
      let(:options) { {} }

      it "does not become accessible in the DTO" do
        expect(subject.first).to_not respond_to(:orders)
        expect(subject.first).to_not respond_to(:person)
        expect(subject.second).to_not respond_to(:orders)
        expect(subject.second).to_not respond_to(:person)
      end
    end
  end
end
