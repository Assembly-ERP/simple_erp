# frozen_string_literal: true

class AddPriceColInOrder < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :price, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
