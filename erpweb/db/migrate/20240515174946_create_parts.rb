# db/migrate/#########_create_parts.rb
class CreateParts < ActiveRecord::Migration[7.1]
  def change
    create_table :parts do |t|
      t.string :name
      t.text :description
      t.decimal :price, precision: 10, scale: 2
      t.integer :in_stock
      t.decimal :weight, precision: 10, scale: 2
      t.json :json_attributes
      t.boolean :manual_price, default: false
      t.boolean :inventory, default: false

      t.timestamps
    end
  end
end
