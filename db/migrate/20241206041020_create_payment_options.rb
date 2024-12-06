# frozen_string_literal: true

class CreatePaymentOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_options do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.boolean :active, null: false, default: false
      t.string :api_url
      t.string :api_token

      t.timestamps
    end

    add_index :payment_options, :code, unique: true

    reversible do |dir|
      dir.up do
        PaymentOption.create(name: 'Ngnair Payments', code: 'ngnair', active: true)
      end
    end
  end
end
