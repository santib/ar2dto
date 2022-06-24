# frozen_string_literal: true

class Car < ActiveRecord::Base
  has_dto class_name: "VehicleDTO"
end
