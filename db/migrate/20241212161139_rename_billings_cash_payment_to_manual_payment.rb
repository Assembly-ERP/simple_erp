# frozen_string_literal: true

class RenameBillingsCashPaymentToManualPayment < ActiveRecord::Migration[7.1]
  def change
    rename_column :billings, :cash_payment, :manual_price
  end
end
