# frozen_string_literal: true

class CreateOrderShippingAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :order_shipping_addresses do |t|
      t.references :order, null: false, foreign_key: true
      t.string :name, default: ''
      t.string :phone, default: ''
      t.string :street, default: ''
      t.string :city, default: ''
      t.string :state, default: ''
      t.string :zip_code, default: ''

      t.timestamps
    end
  end
end
