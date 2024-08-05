class CreateOrderDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :order_details do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: true, foreign_key: true
      t.references :part, null: true, foreign_key: true
      t.integer :quantity
      t.decimal :price, precision: 10, scale: 2

      t.timestamps
    end

    change_column_null :order_details, :product_id, true
    change_column_null :order_details, :part_id, true
    add_check_constraint :order_details, "(product_id IS NOT NULL) OR (part_id IS NOT NULL)", name: "product_or_part_present_check"
  end
end
