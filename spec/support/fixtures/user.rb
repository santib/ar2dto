# frozen_string_literal: true

class User < ActiveRecord::Base
  has_many :orders, class_name: "Shop::Order"
  has_one :person

  if ActiveRecord::VERSION::MAJOR >= 8
    enum :status, { pending: 0, confirmed: 1 }
  else
    enum status: { pending: 0, confirmed: 1 }
  end

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

  def myself
    self
  end

  def other
    Other.new(text: strange_name)
  end

  def poro
    SimplePoro.new(created_at: created_at)
  end

  def dto
    to_dto
  end

  def last_laughed_at
    Time.new(2020, 2, 2)
  end
end
