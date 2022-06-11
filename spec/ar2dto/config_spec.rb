# frozen_string_literal: true

RSpec.describe AR2DTO::Config do
  describe "#reset!" do
    subject { described_class.reset! }

    context "when it has a prior configuration" do
      before do
        described_class.instance.except = [:updated_at]
      end

      it "resets the configuration" do
        expect { subject }.to change {
          described_class.instance.except
        }.from([:updated_at]).to([])
      end
    end
  end

  describe "#instance" do
    context "when configuring an known specification" do
      it "stores the configuration in the class" do
        described_class.instance.except = [:updated_at]

        expect(described_class.instance.except).to eq([:updated_at])
      end
    end

    context "when configuring an unknown specification" do
      it "raises a no method error" do
        expect do
          described_class.instance.unknown_specification = [:updated_at]
        end.to raise_error(NoMethodError)
      end
    end
  end
end
