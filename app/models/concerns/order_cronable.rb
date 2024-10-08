# frozen_string_literal: true

module OrderCronable
  extend ActiveSupport::Concern

  included do
    def calculate_total_amount_cron
      base_price, total_amount = price_calculation

      update_column(:price, base_price)
      update_column(:total_amount, total_amount)
    end
  end

  class_methods do
    def recalculate_price
      active_scheduler = OrderPriceScheduler.find_by(active: true)
      return if active_scheduler.blank?

      case active_scheduler.code
      when 'PER_MONTH'
        Order.per_month_scheduler
      end
    end

    def per_month_scheduler
      orders = Order.joins(:order_status)
                    .where(voided_at: nil, order_status: { customer_locked: false })
                    .where('orders.last_scheduled <=?', 1.month.ago)

      orders.each do |order|
        order.order_details.map(&:calculate_price)
        order.calculate_total_amount_cron
        order.update_column(:last_scheduled, Time.zone.now)
      end
    end
  end
end
