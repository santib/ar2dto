# frozen_string_literal: true

RSpec.describe "#to_dto" do
  describe "attributes" do
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

      it { is_expected.to be_a(UserDTO) }

      it "doesn't expose ActiveRecord's methods" do
        expect(subject).not_to respond_to(:update)
      end

      it "exposes methods to access the columns" do
        expect(subject).to have_attributes(attributes)
      end

      it "exposes methods to access the columns set in the schema" do
        expect(subject).to have_attributes(
          id: nil,
          created_at: nil,
          updated_at: nil
        )
      end

      it "is not possible to set values from outside" do
        expect(subject).to_not respond_to(:first_name=)
      end
    end

    context "when active record is persisted" do
      let(:user) { User.create!(attributes) }

      it { is_expected.to be_a(UserDTO) }

      it "doesn't expose ActiveRecord's methods" do
        expect(subject).not_to respond_to(:update)
      end

      it "exposes methods to access the columns" do
        expect(subject).to have_attributes(attributes)
      end

      it "exposes methods to access the columns set by persistence" do
        expect(subject).to have_attributes(
          id: user.id,
          created_at: user.created_at,
          updated_at: user.updated_at
        )
      end

      it "is not possible to set values from outside" do
        expect(subject).to_not respond_to(:first_name=)
      end
    end
  end
end
