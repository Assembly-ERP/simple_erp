# frozen_string_literal: true

class AddTaxColInOrdersTable < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :tax, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
