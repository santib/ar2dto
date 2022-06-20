# frozen_string_literal: true

class Person < ActiveRecord::Base
  belongs_to :user

  has_dto
end
