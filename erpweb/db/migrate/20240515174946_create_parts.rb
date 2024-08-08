# frozen_string_literal: true

# db/migrate/#########_create_parts.rb
class CreateParts < ActiveRecord::Migration[7.1]
  def change
    create_table :parts do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, default: 0.00
      t.integer :in_stock, default: 0
      t.decimal :weight, precision: 10, scale: 2, default: 0.00
      t.json :json_attributes
      t.boolean :manual_price, default: false, null: false
      t.boolean :inventory, default: false, null: false

      t.timestamps
    end
  end
end
