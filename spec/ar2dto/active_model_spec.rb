# frozen_string_literal: true

RSpec.describe "AR2DTO::ActiveModel" do
  subject { user.to_dto }

  let(:attributes) do
    {
      first_name: "Sandy",
      email: "sandy@example.com",
      birthday: Time.new(1995, 8, 25),
      status: "pending"
    }
  end

  context "when active record is in memory" do
    let(:user) { User.new(attributes) }

    it_behaves_like "ActiveModel"

    it "implements ActiveModel::Translation using the original model" do
      I18n.reload!
      I18n.backend.store_translations "es", activemodel: {
        attributes: { user: { birthday: "Fecha de nacimiento" } }
      }

      I18n.with_locale("es") do
        expect(subject.class.human_attribute_name("birthday")).to eq("Fecha de nacimiento")
      end
    end

    it "implements model_name using the original model" do
      expect(subject.class.to_s).to eq("UserDTO")
      expect(subject.model_name).to eq("User")
      expect(subject.class.model_name).to eq("User")
    end

    it "implements to_partial_path using the original model" do
      expect(subject.to_partial_path).to eq("users/user")
    end
  end

  context "when active record is persisted" do
    let(:user) { User.create(attributes) }

    it_behaves_like "ActiveModel"

    it "implements ActiveModel::Translation using the original model" do
      I18n.reload!
      I18n.backend.store_translations "es", activemodel: {
        attributes: { user: { birthday: "Fecha de nacimiento" } }
      }

      I18n.with_locale("es") do
        expect(subject.class.human_attribute_name("birthday")).to eq("Fecha de nacimiento")
      end
    end

    it "implements model_name using the original model" do
      expect(subject.class.to_s).to eq("UserDTO")
      expect(subject.model_name).to eq("User")
      expect(subject.class.model_name).to eq("User")
    end

    it "implements to_partial_path using the original model" do
      expect(subject.to_partial_path).to eq("users/user")
    end
  end
end
