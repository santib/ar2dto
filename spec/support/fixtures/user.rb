# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :orders, class_name: "Shop::Order"
  has_one :person

  has_dto

  def full_name
    "#{first_name} #{last_name}"
  end

  def strange_name
    "Strange #{first_name}"
  end
end
