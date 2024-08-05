class CreateJoinTableProductsParts < ActiveRecord::Migration[7.1]
  def change
    create_join_table :products, :parts do |t|
      t.index [:product_id, :part_id]
      t.index [:part_id, :product_id]
      t.integer :quantity
    end
  end
end
