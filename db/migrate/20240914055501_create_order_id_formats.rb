# frozen_string_literal: true

class CreateOrderIdFormats < ActiveRecord::Migration[7.1]
  def change
    create_table :order_id_formats do |t|
      t.string :format, null: false
      t.boolean :active, null: false, default: false
      t.string :example, null: true

      t.timestamps
    end

    add_index :order_id_formats, :format, unique: true

    reversible do |dir|
      dir.up do
        OrderIdFormat.create(format: 'default', active: false, example: '1')
        OrderIdFormat.create(format: 'yearly', active: true, example: '2024-0001')
      end
    end
  end
end
