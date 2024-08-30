# frozen_string_literal: true

class AddVoidedAtColInOrderTable < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :voided_at, :datetime
  end
end
