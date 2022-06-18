# frozen_string_literal: true

require "spec_helper"

RSpec.describe ".has_dto" do
  it "creates a new DTO class" do
    expect(Object.const_defined?("UserDTO")).to be true

    expect(UserDTO.superclass).to eq AR2DTO::DTO
  end

  it "creates the new DTO class in the correct namespace" do
    expect(Shop.const_defined?("OrderDTO")).to be true
  end

  context "when the class already exists" do
    it "does not create a new class" do
      expect(Object.const_defined?("PersonDTO")).to be true

      expect(PersonDTO.superclass).to_not eq AR2DTO::DTO
    end
  end

  describe "#to_dto" do
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

    it "is not possible to set values from outside" do
      expect { subject.first_name = "Martin" }.to raise_error(NoMethodError)
    end

    context "when including methods" do
      let(:options) do
        { methods: [:full_name] }
      end

      it "becomes accessible in the DTO" do
        expect(subject.full_name).to eq("Sandy Doe")
      end
    end

    context "when including associations" do
      let(:options) do
        { include: [:orders] }
      end

      before do
        user.orders.new
      end

      it "becomes accessible in the DTO" do
        expect(subject.orders).to be_an(Array)
        expect(subject.orders.first).to be_an(Shop::OrderDTO)
      end

      it "is equal to another DTO of the same class with different data for associations" do
        user_with_same_attributes = User.new(attributes)

        expect(subject).to eq(user_with_same_attributes.to_dto(include: :orders))
      end
    end

    context "when excluding attributes via except" do
      let(:options) do
        { except: [:first_name] }
      end

      it "becomes inaccessible in the DTO" do
        expect { subject.first_name }.to raise_error(NoMethodError)
        expect(subject.last_name).to eq("Doe")
      end
    end

    context "when excluding attributes via only" do
      let(:options) do
        { only: [:last_name] }
      end

      it "becomes inaccessible in the DTO" do
        expect { subject.first_name }.to raise_error(NoMethodError)
        expect(subject.last_name).to eq("Doe")
      end
    end

    context "when active record is persisted" do
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

      let(:user) { User.create!(attributes) }

      it { is_expected.to be_a(UserDTO) }

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
        user_with_same_attributes = User.create!(attributes)

        expect(subject).not_to eq(user_with_same_attributes.to_dto)
      end

      it "is not equal to another DTO of another class with same attributes" do
        admin = double("Admin", user.attributes)

        expect(subject).not_to eq(admin)
      end

      it "is not possible to set values from outside" do
        expect { subject.first_name = "Martin" }.to raise_error(NoMethodError)
      end

      context "when including associations" do
        let(:options) do
          { include: [:orders] }
        end

        before do
          user.orders.create!
        end

        it "becomes accessible in the DTO" do
          expect(subject.orders).to be_an(Array)
          expect(subject.orders.first).to be_an(Shop::OrderDTO)
          expect(subject.orders.first.user_id).to eq(user.id)
          expect(subject.orders.first.user_id).to_not be_nil
        end

        it "is equal to another DTO of the same class with different data for associations" do
          expect(subject).to eq(user.to_dto)
        end
      end

      context "when excluding attributes via except" do
        let(:options) do
          { except: [:first_name] }
        end

        it "becomes inaccessible in the DTO" do
          expect { subject.first_name }.to raise_error(NoMethodError)
          expect(subject.last_name).to eq("Doe")
        end
      end

      context "when excluding attributes via only" do
        let(:options) do
          { only: [:last_name] }
        end

        it "becomes inaccessible in the DTO" do
          expect { subject.first_name }.to raise_error(NoMethodError)
          expect(subject.last_name).to eq("Doe")
        end
      end
    end

    describe "with options" do
      describe "option except" do
        context "when it is configured globally" do
          before do
            # configure excluded attributes globally
            AR2DTO.configure do |config|
              config.except = [:updated_at]
            end
          end

          it "doesn't expose the attribute" do
            # create a new anonymous class that uses has_dto with the new config
            klass = Class.new(ActiveRecord::Base) do
              self.table_name = :users

              def self.name
                "Anonymous"
              end

              has_dto
            end

            expect(klass.new.to_dto).not_to respond_to(:updated_at)
          end
        end
      end
    end

    context "with a namespaced model" do
      let(:attributes) do
        {
          user_id: 1
        }
      end
      let(:options) { {} }

      subject { order.to_dto(options) }

      let(:order) { Shop::Order.new(attributes) }

      it { is_expected.to be_a(Shop::OrderDTO) }
    end
  end

  describe ".to_dto" do
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

    context "when including methods" do
      let(:options) do
        { methods: [:full_name] }
      end

      it "becomes accessible in the DTOs" do
        expect(subject.first.full_name).to eq("Sandy Doe")
        expect(subject.second.full_name).to eq("Kent Simpson")
      end
    end

    context "when including associations" do
      let(:options) do
        { include: [:orders] }
      end

      before do
        user.orders.create!
        another_user.orders.create!
      end

      it "becomes accessible in the DTOs" do
        expect(subject.first.orders).to be_an(Array)
        expect(subject.first.orders.first).to be_an(Shop::OrderDTO)
        expect(subject.first.orders.first.user_id).to eq(user.id)
        expect(subject.first.orders.first.user_id).to_not be_nil
        expect(subject.second.orders).to be_an(Array)
        expect(subject.second.orders.first).to be_an(Shop::OrderDTO)
        expect(subject.second.orders.first.user_id).to eq(another_user.id)
        expect(subject.second.orders.first.user_id).to_not be_nil
      end
    end

    context "when excluding attributes via except" do
      let(:options) do
        { except: [:first_name] }
      end

      it "becomes inaccessible in the DTOs" do
        expect { subject.first.first_name }.to raise_error(NoMethodError)
        expect(subject.first.last_name).to eq("Doe")
        expect { subject.second.first_name }.to raise_error(NoMethodError)
        expect(subject.second.last_name).to eq("Simpson")
      end
    end

    context "when excluding attributes via only" do
      let(:options) do
        { only: [:last_name] }
      end

      it "becomes inaccessible in the DTOs" do
        expect { subject.first.first_name }.to raise_error(NoMethodError)
        expect(subject.first.last_name).to eq("Doe")
        expect { subject.second.first_name }.to raise_error(NoMethodError)
        expect(subject.second.last_name).to eq("Simpson")
      end
    end
  end
end
