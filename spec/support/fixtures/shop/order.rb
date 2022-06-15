# frozen_string_literal: true

module Shop
  class Order < ActiveRecord::Base
    self.table_name = "shop_orders"

    has_dto
  end
end
