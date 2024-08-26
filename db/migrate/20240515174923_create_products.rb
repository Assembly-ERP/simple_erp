# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, default: 0.0
      t.decimal :weight, precision: 10, scale: 2, default: 0.0
      t.boolean :available, default: false, null: false
      t.json :json_attributes

      t.timestamps
    end
  end
end
