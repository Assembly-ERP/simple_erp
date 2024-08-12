# frozen_string_literal: true

class UpdateCustomerColNameUniq < ActiveRecord::Migration[7.1]
  def change
    add_index :customers, :name, unique: true
  end
end
