# frozen_string_literal: true

module OrderCalculable
  extend ActiveSupport::Concern

  included do
    before_save :calculate_total_amount

    def price_calculation
      base_price = order_details.filter_map { |od| (od.price.to_f * od.quantity.to_i) unless od._destroy }.sum
      discount_amount = base_price.to_f * (discount_percentage.to_f / 100).to_f
      total_amount = base_price.to_f - discount_amount.to_f + shipping_price.to_f + tax.to_f

      [base_price, total_amount]
    end

    private

    def calculate_total_amount
      base_price, total_amount = price_calculation

      self.price = base_price
      self.total_amount = total_amount
    end
  end
end
