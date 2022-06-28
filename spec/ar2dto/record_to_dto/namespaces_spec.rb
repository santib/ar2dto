# frozen_string_literal: true

RSpec.describe "#to_dto" do
  describe "namespaces" do
    let(:attributes) do
      {
        user_id: 1
      }
    end

    subject { order.to_dto }

    let(:order) { Shop::Order.new(attributes) }

    it { is_expected.to be_a(Shop::OrderDTO) }

    context "with a custom class_name" do
      let(:attributes) do
        {
          order_id: 1
        }
      end

      subject { line_item.to_dto }

      let(:line_item) { Shop::LineItem.new(attributes) }

      it { is_expected.to be_a(Core::LineItemDTO) }
    end
  end
end
