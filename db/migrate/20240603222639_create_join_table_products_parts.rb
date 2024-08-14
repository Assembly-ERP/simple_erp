# frozen_string_literal: true

class CreateJoinTableProductsParts < ActiveRecord::Migration[7.1]
  def change
    create_join_table :products, :parts do |t|
      t.index %i[product_id part_id]
      t.index %i[part_id product_id]
      t.integer :quantity, default: 1
    end
  end
end
