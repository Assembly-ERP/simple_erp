# frozen_string_literal: true

class OrderPdf
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper
  include Prawn::View

  def initialize(order)
    @order = order
  end

  def document
    @document ||= Prawn::Document.new(page_size: 'A4')
  end

  def make_ticket
    company_details

    text "Make Ticket (Order #{@order.formatted_id})", size: 15, style: :bold

    order_date
    shipping_details

    header = [['Part Name', 'SKU', 'QTY']]

    parts = @order.order_details.make_ticket.map do |item|
      [item.part_name, item.part_sku || 'N/A', item.total_quantity]
    end

    table(header + parts, width: bounds.width) do
      row(0).style font_style: :bold
      column(1).width = 100
      column(2).width = 80
    end

    internal_note
  end

  def quote_or_invoice
    company_details

    text "#{quote? ? 'Quote' : 'Invoice'} (Order #{@order.formatted_id})", size: 15, style: :bold

    order_date
    shipping_details

    header = [['Name', 'SKU', 'Type', 'QTY', 'Price ($)', 'Total ($)']]

    items = @order.order_details.with_part_and_product.map do |item|
      [
        item.product_id ? item.product_name : item.part_name,
        (item.product_id ? item.product_sku : item.part_sku) || 'N/A',
        item.product_id ? 'Product' : 'Part',
        item.quantity,
        number_with_precision(item.price, precision: 2),
        number_with_precision(item.subtotal, precision: 2)
      ]
    end

    table(header + items, width: bounds.width) do
      row(0).style font_style: :bold
      column(1).width = 90
      column(2).width = 60
      column(3).width = 50
      column(4).width = 70
      column(5).width = 70
    end
    move_down 20

    order_summary
  end

  def quote?
    !@order.order_status.customer_locked
  end

  private

  def company_details
    if Branding.client.logo.attached?
      image StringIO.open(Branding.client.logo.download), width: 120
      move_down 15
    end

    text Branding.client.name, size: 18, style: :bold
    move_down 10
  end

  def shipping_details
    text @order.customer.name, size: 14
    move_down 15

    return if (shipping = @order.order_shipping_address).blank?

    text shipping.name if shipping.name.present?
    text shipping.street if shipping.street.present?
    if shipping.state.blank? && shipping.city.blank? && shipping.zip_code.blank?
      text "#{shipping.state.present? ? "#{shipping.state}," : ''} #{shipping.city} #{shipping.zip_code}"
    end
    text shipping.phone if shipping.phone.present?
    move_down 15
  end

  def order_summary
    discount_value = value_from_percentage(@order.price, @order.discount_percentage)
    subtotal = @order.price - discount_value + @order.tax.to_f
    summary_items = [
      ['Order Summary', ''],
      ['Base Price', number_to_currency(@order.price, precision: 2)],
      [
        "Discount (#{number_with_precision(@order.discount_percentage, precision: 2)}%)",
        "-#{number_to_currency(discount_value, precision: 2)}"
      ],
      ['Tax', number_to_currency(@order.tax, precision: 2)],
      ['Subtotal', number_to_currency(subtotal, precision: 2)],
      ['Shipping', quote? ? 'TBA' : number_to_currency(@order.shipping_price, precision: 2)],
      ['Order Total', number_to_currency(@order.total_amount, precision: 2)]
    ]

    table(summary_items, position: :right, cell_style: { padding: [2, 0], border_width: 0 }) do
      row(0).style font_style: :bold, size: 13
      row(0).style padding: [0, 0, 5, 0]
      row(5).style padding: [7, 0, 2, 0]
      row(6).style font_style: :bold
      column(0).width = 100
      column(1).width = 80
      column(1).style align: :right
    end
  end

  def order_date
    text @order.created_at.strftime('%m/%d/%Y')
    move_down 10
  end

  def internal_note
    return if @order.internal_note.blank?

    move_down 15
    text 'Note:', style: :bold
    move_down 2
    text @order.internal_note
  end
end
