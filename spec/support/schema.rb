# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: true do |t|
    t.string :first_name
    t.string :last_name
    t.string :email, null: false
    t.datetime :birthday
    t.integer :status, default: 0

    t.timestamps
  end

  create_table :people, force: true do |t|
    t.bigint :user_id
    t.string :first_name
    t.string :last_name
    t.datetime :birthday

    t.timestamps
  end

  create_table :shop_orders, force: true do |t|
    t.bigint :user_id

    t.timestamps
  end

  create_table :cars, force: true do |t|
    t.string :model

    t.timestamps
  end

  create_table :shop_line_items, force: true do |t|
    t.bigint :order_id
    t.string :name
    t.bigint :price

    t.timestamps
  end

  create_table :others, force: true do |t|
    t.text :text

    t.timestamps
  end
end
