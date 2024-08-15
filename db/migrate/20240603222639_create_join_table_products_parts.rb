# frozen_string_literal: true

class CreateJoinTableProductsParts < ActiveRecord::Migration[7.1]
  def change
    create_join_table :products, :parts do |t|
      t.index %i[part_id product_id], unique: true
      t.integer :quantity, default: 1
    end
  end
end
