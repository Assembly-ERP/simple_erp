# frozen_string_literal: true

class CartIndexUserToPartAndRoduct < ActiveRecord::Migration[7.1]
  def change
    add_index :carts, %i[user_id part_id product_id], unique: true
  end
end
