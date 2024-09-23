# frozen_string_literal: true

if ENV['USER_IMPORT_FILE'].present?
  require 'csv'

  path = Rails.root.join("imports/#{ENV['USER_IMPORT_FILE']}")

  downcase_converter = ->(header) { header.downcase }
  table = CSV.parse(File.read(path), headers: true, header_converters: downcase_converter)

  table.each do |row|
    product = Part.build(
      name: row['sku'], nmfc: row['nmfc'], description: row['new description'],
      width: row['width'], weight: row['weight']&.chomp('lbs').to_f || 0,
      length: row['length'], sku: row['sku']
    )

    product.save! if product.valid?
  end
end
