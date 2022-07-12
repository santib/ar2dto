# frozen_string_literal: true

RSpec.describe ".to_dto" do
  describe "options" do
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

    context "when including methods" do
      let(:options) do
        { methods: [:full_name] }
      end

      it "becomes accessible in the DTOs" do
        expect(subject.first.full_name).to eq("Sandy Doe")
        expect(subject.second.full_name).to eq("Kent Simpson")
      end

      context "when including methods that return an ActiveRecord object" do
        let(:options) do
          { methods: %i[myself other] }
        end

        context "if it responds to #to_dto" do
          it "gets converted into a DTO" do
            expect(subject.first.myself).to be_a(UserDTO)
            expect(subject.first.myself.first_name).to eq("Sandy")
            expect(subject.second.myself).to be_a(UserDTO)
            expect(subject.second.myself.first_name).to eq("Kent")
          end
        end

        context "if it doesn't respond to #to_dto" do
          it "gets converted into a hash" do
            expect(subject.first.other).to be_a(Hash)
            expect(subject.first.other["text"]).to eq("Strange Sandy")
            expect(subject.second.other).to be_a(Hash)
            expect(subject.second.other["text"]).to eq("Strange Kent")
          end
        end
      end

      context "when including methods that return a PORO" do
        let(:options) do
          { methods: %i[poro] }
        end

        it "gets converted into a hash" do
          expect(subject.first.poro).to be_a(Hash)
          expect(subject.first.poro["created_at"]).to eq(user.created_at.as_json)
          expect(subject.second.poro).to be_a(Hash)
          expect(subject.second.poro["created_at"]).to eq(another_user.created_at.as_json)
        end
      end
    end

    context "when excluding attributes via except" do
      let(:options) do
        { except: [:first_name] }
      end

      it "becomes nil in the DTOs" do
        expect(subject.first.first_name).to be_nil
        expect(subject.first.last_name).to eq("Doe")
        expect(subject.second.first_name).to be_nil
        expect(subject.second.last_name).to eq("Simpson")
      end
    end

    context "when excluding attributes via only" do
      let(:options) do
        { only: [:last_name] }
      end

      it "becomes nil in the DTOs" do
        expect(subject.first.first_name).to be_nil
        expect(subject.first.last_name).to eq("Doe")
        expect(subject.second.first_name).to be_nil
        expect(subject.second.last_name).to eq("Simpson")
      end
    end
  end
end
