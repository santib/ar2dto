# frozen_string_literal: true

RSpec.describe "#to_dto" do
  describe "options" do
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

      context "when including methods" do
        let(:options) do
          { methods: [:full_name] }
        end

        it "becomes accessible in the DTO" do
          expect(subject.full_name).to eq("Sandy Doe")
        end

        it "is not possible to call methods that weren't added" do
          expect(subject).to_not respond_to(:strange_name)
        end
      end

      context "when excluding attributes via except" do
        let(:options) do
          { except: [:first_name] }
        end

        it "becomes inaccessible in the DTO" do
          expect(subject).to_not respond_to(:first_name)
          expect(subject.last_name).to eq("Doe")
        end
      end

      context "when excluding attributes via only" do
        let(:options) do
          { only: %i[last_name birthday] }
        end

        it "becomes inaccessible in the DTO" do
          expect(subject).to_not respond_to(:first_name)
          expect(subject.last_name).to eq("Doe")
          expect(subject.birthday).to eq(Time.new(1995, 8, 25))
        end
      end
    end

    context "when active record is persisted" do
      let(:user) { User.create!(attributes) }

      context "when including methods" do
        let(:options) do
          { methods: [:full_name] }
        end

        it "becomes accessible in the DTO" do
          expect(subject.full_name).to eq("Sandy Doe")
        end

        it "is not possible to call methods that weren't added" do
          expect(subject).to_not respond_to(:strange_name)
        end
      end

      context "when excluding attributes via except" do
        let(:options) do
          { except: [:first_name] }
        end

        it "becomes inaccessible in the DTO" do
          expect(subject).to_not respond_to(:first_name)
          expect(subject.last_name).to eq("Doe")
        end
      end

      context "when excluding attributes via only" do
        let(:options) do
          { only: [:last_name] }
        end

        it "becomes inaccessible in the DTO" do
          expect(subject).to_not respond_to(:first_name)
          expect(subject.last_name).to eq("Doe")
        end
      end
    end
  end
end
