# frozen_string_literal: true

RSpec.describe "#to_dto" do
  describe "namespaces" do
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
end
