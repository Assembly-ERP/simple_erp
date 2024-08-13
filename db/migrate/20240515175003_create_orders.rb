# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :status, null: false
      t.decimal :total_amount, precision: 10, scale: 2, default: 0

      t.timestamps
    end
  end
end
