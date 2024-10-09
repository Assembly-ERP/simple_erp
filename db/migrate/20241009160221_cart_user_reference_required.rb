# frozen_string_literal: true

class CartUserReferenceRequired < ActiveRecord::Migration[7.1]
  def change
    reversible do |dir|
      dir.up do
        change_column :carts, :user_id, :bigint, null: false
      end
    end
  end
end
