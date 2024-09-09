# frozen_string_literal: true

class CreateOrderStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :order_statuses do |t|
      t.string :name, null: false
      t.boolean :locked, null: false, default: false
      t.boolean :reversed, null: false, default: false
      t.boolean :default, null: false, default: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        OrderStatus.create(name: 'Pre Order', locked: false, default: true)
        OrderStatus.create(name: 'New', locked: false)
        OrderStatus.create(name: 'Submitted', locked: true)
        OrderStatus.create(name: 'Cancelled', locked: true, reversed: true)
        OrderStatus.create(name: 'Returned', locked: true, reversed: true)
      end
    end
  end
end
