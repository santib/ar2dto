# frozen_string_literal: true

RSpec.describe AR2DTO::DTO do
  let(:klass) do
    Class.new(described_class[User]) do
      def self.name
        "AnonymousDTO"
      end
    end
  end

  let(:attributes) do
    {
      first_name: "Sandy",
      last_name: "Doe",
      email: "sandy@example.com",
      birthday: Time.new(1995, 8, 25),
      status: "pending"
    }
  end
  let(:user) { User.new(attributes) }

  context "initialized with value attributes" do
    subject { klass.new(user.attributes) }

    it "responds to defined methods" do
      expect(subject.first_name).to eq("Sandy")
    end

    it "implements equality" do
      expect(subject).to eq(klass.new(user.attributes))
      expect(subject).to_not eq(klass.new(user.attributes.merge("first_name" => "Other")))
    end

    it "does not respond to other methods" do
      expect(subject).to_not respond_to(:undefined_method)
    end

    it_behaves_like "ActiveModel"
  end

  context "#as_json" do
    subject { klass.new(user.attributes).as_json(options) }

    let(:options) { nil }

    it "responds to defined methods" do
      expect(subject).to eq(user.attributes.as_json)
    end

    context "with options" do
      let(:options) { { except: "first_name" } }

      it "affects the result" do
        expect(subject).to eq(user.attributes.as_json.except("first_name"))
      end
    end
  end
end
