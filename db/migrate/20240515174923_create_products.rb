# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :sku
      t.text :description
      t.decimal :price, precision: 10, scale: 2, default: 0.0
      t.decimal :weight, precision: 10, scale: 2, default: 0.0
      t.boolean :available, default: false, null: false
      t.datetime :voided_at
      t.string :nmfc
      t.string :category

      t.timestamps
    end

    add_index :products, :name
    add_index :products, :voided_at
    add_index :products, :sku, unique: true
  end
end
