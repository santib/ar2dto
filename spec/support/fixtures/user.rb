# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :orders, class_name: "Shop::Order"
  has_one :person

  enum status: { pending: 0, confirmed: 1 }

  has_dto

  def full_name
    "#{first_name} #{last_name}"
  end

  def strange_name
    "Strange #{first_name}"
  end

  def superman?
    full_name == "Clark Kent"
  end
end
