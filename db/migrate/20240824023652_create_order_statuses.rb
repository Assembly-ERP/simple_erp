# frozen_string_literal: true

class CreateOrderStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :order_statuses do |t|
      t.string :name, null: false
      t.boolean :customer_locked, null: false, default: false
      t.boolean :operation_locked, null: false, default: false
      t.boolean :reversed, null: false, default: false
      t.boolean :default, null: false, default: false
      t.boolean :allow_change, null: false, default: true

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        OrderStatus.create(name: 'Quote', default: true)
        OrderStatus.create(name: 'New', customer_locked: true, operation_locked: false)
        OrderStatus.create(name: 'Scheduled', customer_locked: true, operation_locked: true)
        OrderStatus.create(name: 'Completed', customer_locked: true, operation_locked: true)
        OrderStatus.create(name: 'Shipped', customer_locked: true, operation_locked: true)
        OrderStatus.create(name: 'Billed', customer_locked: true, operation_locked: true)
        OrderStatus.create(name: 'Paid', customer_locked: true, operation_locked: true)
        OrderStatus.create(
          name: 'Cancelled', customer_locked: true, operation_locked: true, reversed: true, allow_change: false
        )
      end
    end
  end
end
