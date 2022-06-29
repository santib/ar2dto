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

        expect(klass.new.to_dto).to_not respond_to(:updated_at)
      end
    end
  end

  describe "option class_name" do
    it "respects the custom class_name" do
      expect(Car.new.to_dto).to be_a(VehicleDTO)
    end
  end

  describe "option replace_suffix" do
    before do
      # configure replace_suffix globally
      AR2DTO.configure do |config|
        config.replace_suffix = replace_suffix
      end
    end

    let(:replace_suffix) do
      { from: "Record", to: "Value" }
    end

    it "uses the class suffix when creating the dynamic class" do
      # create a new anonymous class that uses has_dto with the new config
      klass = Class.new(ActiveRecord::Base) do
        self.table_name = :users

        def self.name
          "MyClassRecord"
        end

        has_dto
      end

      expect(klass.new.to_dto).to be_a(MyClassValue)
    end

    context "removing a suffix" do
      let(:replace_suffix) do
        { from: "Record", to: "" }
      end

      it "uses the class suffix when creating the dynamic class" do
        # create a new anonymous class that uses has_dto with the new config
        klass = Class.new(ActiveRecord::Base) do
          self.table_name = :users

          def self.name
            "AnonymousRecord"
          end

          has_dto
        end

        expect(klass.new.to_dto).to be_a(Anonymous)
      end
    end
  end

  describe "option active_model_compliance" do
    context "when it is true" do
      before do
        # configure active_model_compliance globally
        AR2DTO.configure do |config|
          config.active_model_compliance = true
        end
      end

      it "responds to ActiveModel methods" do
        # create a new anonymous class that uses has_dto with the new config
        klass = Class.new(ActiveRecord::Base) do
          self.table_name = :users

          def self.name
            "Something"
          end

          has_dto
        end

        expect(klass.new.to_dto).to respond_to(:persisted?)
      end
    end

    context "when it is false" do
      before do
        # configure active_model_compliance globally
        AR2DTO.configure do |config|
          config.active_model_compliance = false
        end
      end

      it "doesn't respond to ActiveModel methods" do
        # create a new anonymous class that uses has_dto with the new config
        klass = Class.new(ActiveRecord::Base) do
          self.table_name = :users

          def self.name
            "SomethingElse"
          end

          has_dto
        end

        expect(klass.new.to_dto).not_to respond_to(:persisted?)
      end
    end
  end
end
