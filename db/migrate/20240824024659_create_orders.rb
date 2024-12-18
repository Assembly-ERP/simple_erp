# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :formatted_id, null: false
      t.references :customer, null: false, foreign_key: true
      t.decimal :total_amount, precision: 10, scale: 2, default: 0
      t.references :order_status, null: false, foreign_key: true
      t.decimal :shipping_price, precision: 10, scale: 2, default: 0.0
      t.decimal :discount_percentage, precision: 5, scale: 2, default: 0.0
      t.decimal :price, precision: 10, scale: 2, default: 0.0
      t.decimal :tax, precision: 10, scale: 2, default: 0.0
      t.datetime :voided_at
      t.datetime :last_scheduled, default: -> { 'now()' }
      t.boolean :send_quote_assignees, null: false, default: true
      t.integer :holder_id
      t.text :internal_note

      t.timestamps
    end

    add_index :orders, :formatted_id, unique: true
    add_index :orders, :voided_at
    add_index :orders, :last_scheduled
  end
end
