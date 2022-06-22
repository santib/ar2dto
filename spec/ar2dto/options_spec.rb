# frozen_string_literal: true

RSpec.describe "options" do
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
