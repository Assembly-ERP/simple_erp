# frozen_string_literal: true

class AddOrderColShippingPriceAndDiscount < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :shipping_price, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :orders, :discount_percentage, :decimal, precision: 5, scale: 2, default: 0.0
  end
end
