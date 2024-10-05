# frozen_string_literal: true

class AddOrderDetailIndexPartAndProduct < ActiveRecord::Migration[7.1]
  def change
    add_index :order_details, %i[order_id part_id product_id], unique: true
  end
end
