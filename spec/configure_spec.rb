# frozen_string_literal: true

RSpec.describe "AR2DTO.configure" do
  context "when setting except" do
    it "stores the configuration" do
      AR2DTO.configure do |config|
        config.except = [:updated_at]
      end

      expect(AR2DTO.configure.except).to eq([:updated_at])
    end
  end

  context "when setting invalid configuration params" do
    it "raises an undefined method error" do
      expect do
        AR2DTO.configure do |config|
          config.invalid_configuration = [:invalid]
        end
      end.to raise_error(NoMethodError)
    end
  end
end
