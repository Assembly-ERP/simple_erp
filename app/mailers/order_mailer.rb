# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  layout false
  helper :application

  def send_quote_or_invoice(order)
    @order = order
    @is_quote = !@order.order_status.customer_locked

    @order.users.each do |user|
      mail(to: user.email, subject: "#{@is_quote ? 'Quote' : 'Invoice'}: Order #{@order.id}")
    end
  end
end
