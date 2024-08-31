# frozen_string_literal: true

class CreateOrderShippingAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :order_shipping_addresses do |t|
      t.references :order, null: false, foreign_key: true
      t.string :street, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, default: ''

      t.timestamps
    end
  end
end
