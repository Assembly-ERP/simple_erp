# frozen_string_literal: true

class CreateBillings < ActiveRecord::Migration[7.1]
  def change
    create_table :billings do |t|
      t.boolean :cash_payment, null: false, default: true

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Billing.create(cash_payment: true)
      end
    end
  end
end
