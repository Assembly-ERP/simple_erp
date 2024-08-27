# frozen_string_literal: true

class CreateOrderAssignees < ActiveRecord::Migration[7.1]
  def change
    create_table :order_assignees do |t|
      t.references :order, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
