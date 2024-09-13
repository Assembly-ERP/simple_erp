# frozen_string_literal: true

class CreateOrderStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :order_statuses do |t|
      t.string :name, null: false
      t.boolean :customer_locked, null: false, default: false
      t.boolean :operation_locked, null: false, default: false
      t.boolean :reversed, null: false, default: false
      t.boolean :default, null: false, default: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        OrderStatus.create(name: 'Pre Order', default: true)
        OrderStatus.create(name: 'New', customer_locked: true, operation_locked: false)
        OrderStatus.create(name: 'Submitted', customer_locked: true, operation_locked: true)
        OrderStatus.create(name: 'Cancelled', customer_locked: true, operation_locked: true, reversed: true)
        OrderStatus.create(name: 'Returned', customer_locked: true, operation_locked: true, reversed: true)
      end
    end
  end
end
