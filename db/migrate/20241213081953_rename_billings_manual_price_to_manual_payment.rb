# frozen_string_literal: true

class RenameBillingsManualPriceToManualPayment < ActiveRecord::Migration[7.1]
  def change
    rename_column :billings, :manual_price, :manual_payment
  end
end
