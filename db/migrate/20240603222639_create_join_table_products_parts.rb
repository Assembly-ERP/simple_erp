# frozen_string_literal: true

class CreateJoinTableProductsParts < ActiveRecord::Migration[7.1]
  def change
    create_table :parts_products do |t|
      t.references :part, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, default: 1

      t.timestamps
    end

    add_index :parts_products, %i[part_id product_id], unique: true
  end
end
