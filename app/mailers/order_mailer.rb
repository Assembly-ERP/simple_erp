# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  layout false
  helper :application

  def send_quote_or_invoice(order)
    @order = order
    @is_quote = !@order.order_status.customer_locked

    pdf = OrderPdf.new(@order)
    pdf.quote_or_invoice
    filename = "order_#{@is_quote ? 'quote' : 'invoice'}_#{@order.formatted_id}_#{Time.zone.now.to_i}.pdf"
    attachments[filename] = { mime_type: 'application/pdf', content: pdf.render }

    @order.users.each do |user|
      mail(to: user.email, subject: "#{@is_quote ? 'Quote' : 'Invoice'}: Order #{@order.formatted_id}")
    end
  end
end
