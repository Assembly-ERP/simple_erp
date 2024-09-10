# frozen_string_literal: true

class CreateOrderPriceSchedulers < ActiveRecord::Migration[7.1]
  def change
    create_table :order_price_schedulers do |t|
      t.string :code
      t.string :name
      t.boolean :active, null: false, default: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        OrderPriceScheduler.create(code: 'PER_MONTH', name: 'Per month', active: true)
      end
    end
  end
end
