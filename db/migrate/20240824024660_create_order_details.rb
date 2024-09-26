# frozen_string_literal: true

class CreateOrderDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :order_details do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, foreign_key: true
      t.references :part, foreign_key: true
      t.integer :quantity, default: 1, null: false
      t.decimal :price, precision: 10, scale: 2, default: 0.0
      t.boolean :override, default: false, null: false

      t.timestamps
    end

    add_check_constraint :order_details, '(product_id IS NOT NULL) OR (part_id IS NOT NULL)',
                         name: 'order_detail_product_or_part_present_check'
  end
end
