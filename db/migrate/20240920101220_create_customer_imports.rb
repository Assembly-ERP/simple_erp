# frozen_string_literal: true

class CreateCustomerImports < ActiveRecord::Migration[7.1]
  def change
    create_table :customer_imports do |t|
      t.string :status, null: false, default: 'pending'
      t.references :created_by, foreign_key: { to_table: 'users' }

      t.timestamps
    end
  end
end
