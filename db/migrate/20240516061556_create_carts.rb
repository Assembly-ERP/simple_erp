# frozen_string_literal: true

class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.references :user, foreign_key: true, null: false
      t.references :product, foreign_key: true
      t.references :part, foreign_key: true
      t.integer :quantity, null: false, default: 1

      t.timestamps
    end

    add_check_constraint :carts, '(product_id IS NOT NULL) OR (part_id IS NOT NULL)',
                         name: 'cart_product_or_part_present_check'

    add_index :carts, %i[user_id part_id product_id], unique: true
  end
end
