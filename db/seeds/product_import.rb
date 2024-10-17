# frozen_string_literal: true

if ENV['PRODUCT_IMPORT_FILE'].present?
  require 'csv'

  PRODUCT_DB_COL = %w[
    name
    sku
    description
    nmfc
    category
    width
    weight
    length
  ].freeze

  path = Rails.root.join("imports/#{ENV.fetch('PRODUCT_IMPORT_FILE', nil)}")

  downcase_converter = ->(header) { header.downcase }
  table = CSV.parse(File.read(path), headers: true, header_converters: downcase_converter)

  table.each do |row|
    part = Part.build
    poly_attr_val = []

    row.to_h.each_key do |k|
      next if k.blank?

      value = row[k].to_s

      if PRODUCT_DB_COL.include?(k)
        value = value.chomp('lbs') if value.include?('lbs')
        value = value.chomp('"') if value.last == '"'

        part[k] = value
      else
        poly_attr_val << { input_type: 'text', value:, label: k.humanize }
      end
    end

    next unless part.valid?

    part.save!

    poly_attr_val.each do |value|
      part.poly_attributes.create(value)
    end
  end
end
