# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :phone
      t.string :ein
      t.string :street
      t.string :city
      t.string :state
      t.string :postal_code
      t.decimal :discount, precision: 5, scale: 2, default: 0
      t.datetime :voided_at

      t.timestamps
    end

    add_index :customers, :name, unique: true
  end
end
