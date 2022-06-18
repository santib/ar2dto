# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :orders, class_name: "Shop::Order"

  has_dto

  def full_name
    "#{first_name} #{last_name}"
  end
end
