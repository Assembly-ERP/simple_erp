# frozen_string_literal: true

class AddPayLaterColumnInBillingTable < ActiveRecord::Migration[7.1]
  def change
    add_column :billings, :pay_later, :boolean, default: true, null: false
    add_column :billings, :enable_integration, :boolean, default: false, null: false
  end
end
