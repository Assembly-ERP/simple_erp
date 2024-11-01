# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def theme(branding)
    "--primary: #{branding.primary_color}; --primary-text: #{branding.primary_text_color}; " \
      "--secondary: #{branding.secondary_color}; --secondary-text: #{branding.secondary_text_color};"
  end

  def value_from_percentage(value, percentage)
    value.to_f * (percentage.to_f / 100).to_f
  end

  def format_phone_number(phone)
    return '' if phone.nil?

    phone.gsub(/\D/, '').gsub(/(\d{3})(\d{3})(\d{4})/, '\1-\2-\3')
  end
end
