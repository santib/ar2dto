# frozen_string_literal: true

require "spec_helper"

RSpec.describe "AR2DTO::ActiveModel" do
  subject { user.to_dto }

  let(:attributes) do
    {
      name: "Sandy",
      email: "sandy@example.com",
      birthday: Time.new(1995, 8, 25)
    }
  end

  context "when active record is in memory" do
    let(:user) { User.new(attributes) }

    it_behaves_like "ActiveModel"
  end

  context "when active record is persisted" do
    let(:user) { User.create(attributes) }

    it_behaves_like "ActiveModel"
  end
end
