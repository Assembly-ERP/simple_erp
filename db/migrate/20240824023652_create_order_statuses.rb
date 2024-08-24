# frozen_string_literal: true

class CreateOrderStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :order_statuses do |t|
      t.string :name, null: false
      t.boolean :locked, null: false, default: false
      t.boolean :inventory, null: false, default: false
      t.boolean :reversed, null: false, default: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        OrderStatus.create(name: 'Pre Order', locked: false, inventory: false)
        OrderStatus.create(name: 'New', locked: false, inventory: true)
        OrderStatus.create(name: 'Submitted', locked: true, inventory: true)
        OrderStatus.create(name: 'Cancelled', locked: true, inventory: true, reversed: true)
        OrderStatus.create(name: 'Returned', locked: true, inventory: true, reversed: true)
      end
    end
  end
end
