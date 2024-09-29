# frozen_string_literal: true

module OrderShippingAddressesHelper
  def order_readable_shipping_address(order)
    shipping_address = order.order_shipping_address

    return '' if shipping_address.blank?

    "#{shipping_address.street.present? ? "#{shipping_address.street}, " : ' '}" \
      "#{shipping_address.city.present? ? "#{shipping_address.city}, " : ' '}" \
      "#{shipping_address.state} #{shipping_address.zip_code}"
  end
end
