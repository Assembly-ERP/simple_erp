# frozen_string_literal: true

class UpdatePartAndProductIndexSku < ActiveRecord::Migration[7.1]
  def change
    remove_index :parts, :sku
    add_index :parts, :sku, unique: true, where: "sku IS NOT NULL AND sku != ''"

    remove_index :products, :sku
    add_index :products, :sku, unique: true, where: "sku IS NOT NULL AND sku != ''"
  end
end
