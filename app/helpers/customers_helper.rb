# frozen_string_literal: true

module CustomersHelper
  def format_phone_number(phone)
    return '' if phone.nil?

    phone.gsub(/\D/, '').gsub(/(\d{3})(\d{3})(\d{4})/, '\1-\2-\3')
  end
end
