# frozen_string_literal: true

module Shop
  class LineItem < ActiveRecord::Base
    self.table_name = "shop_line_items"

    belongs_to :order

    has_dto class_name: "Core::LineItemDTO"
  end
end
