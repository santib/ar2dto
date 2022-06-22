# frozen_string_literal: true

RSpec.describe ".to_dto" do
  describe "attributes" do
    let(:relation) { User.all }
    let(:options) { {} }

    subject { relation.to_dto(options) }

    let!(:user) do
      User.create!(first_name: "Sandy", last_name: "Doe", email: "sandy@example.com")
    end
    let!(:another_user) do
      User.create!(first_name: "Kent", last_name: "Simpson", email: "kent@example.com")
    end

    it "returns an array of DTOs" do
      expect(subject).to be_an(Array)
      expect(subject.size).to eq(2)
      expect(subject.first).to be_a(UserDTO)
      expect(subject.second).to be_a(UserDTO)
    end

    context "when the relation is scoped" do
      let(:relation) { User.where(first_name: "Sandy") }

      it "returns the DTO of the matching records" do
        expect(subject).to be_an(Array)
        expect(subject.size).to eq(1)
        expect(subject.first).to be_a(UserDTO)
        expect(subject.first.first_name).to eq("Sandy")
      end
    end
  end
end
