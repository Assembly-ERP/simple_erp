# frozen_string_literal: true

class CreateParts < ActiveRecord::Migration[7.1]
  def change
    create_table :parts do |t|
      t.string :name, null: false
      t.string :sku
      t.text :description
      t.decimal :price, precision: 10, scale: 2, default: 0.00
      t.integer :in_stock, default: 0
      t.decimal :weight, precision: 10, scale: 2, default: 0.00
      t.decimal :length, precision: 10, scale: 2, default: 0.00
      t.decimal :width, precision: 10, scale: 2, default: 0.00
      t.boolean :manual_price, default: false, null: false
      t.boolean :inventory, default: false, null: false
      t.datetime :voided_at
      t.string :nmfc
      t.string :category

      t.timestamps
    end

    add_index :parts, :name
    add_index :parts, :voided_at
    add_index :parts, :sku, unique: true, where: "sku IS NOT NULL AND sku != '' AND voided_at IS NULL"
  end
end
