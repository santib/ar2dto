# frozen_string_literal: true

RSpec.describe "#to_dto" do
  describe "associations" do
    let(:attributes) do
      {
        first_name: "Sandy",
        last_name: "Doe",
        email: "sandy@example.com",
        birthday: Time.new(1995, 8, 25),
        status: "pending"
      }
    end

    subject { user.to_dto(options) }

    context "when including associations" do
      let(:options) do
        { include: %i[orders person] }
      end

      context "when active record is in memory" do
        let(:user) { User.new(attributes) }

        before do
          user.orders.new
          user.build_person
        end

        it "becomes accessible in the DTO" do
          expect(subject.orders).to be_an(Array)
          expect(subject.orders.first).to be_an(Shop::OrderDTO)
          expect(subject.person).to be_a(PersonDTO)
        end
      end

      context "when active record is persisted" do
        let(:user) { User.create!(attributes) }

        before do
          user.orders.create!
          user.create_person!
        end

        it "becomes accessible in the DTO" do
          expect(subject.orders).to be_an(Array)
          expect(subject.orders.first).to be_an(Shop::OrderDTO)
          expect(subject.orders.first.user_id).to eq(user.id)
          expect(subject.orders.first.user_id).to_not be_nil
          expect(subject.person).to be_a(PersonDTO)
          expect(subject.person.user_id).to eq(user.id)
        end
      end
    end

    context "when not including associations" do
      let(:options) { {} }
      let(:user) { User.new(attributes) }

      before do
        user.orders.new
        user.build_person
      end

      it "does not become accessible in the DTO" do
        expect(subject).to_not respond_to(:orders)
        expect(subject).to_not respond_to(:person)
      end
    end
  end
end
