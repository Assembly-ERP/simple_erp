# frozen_string_literal: true

class CartRemoveColCustomer < ActiveRecord::Migration[7.1]
  def change
    remove_reference :carts, :customer, index: true, foreign_key: true
  end
end
