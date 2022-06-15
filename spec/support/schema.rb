# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string :name
    t.string :email, null: false
    t.datetime :birthday

    t.timestamps
  end

  create_table :people, force: true do |t|
    t.string :name
    t.datetime :birthday

    t.timestamps
  end

  create_table :shop_orders, force: true do |t|
    t.bigint :user_id

    t.timestamps
  end
end
