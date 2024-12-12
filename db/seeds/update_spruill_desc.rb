# frozen_string_literal: true

require 'csv'

path = Rails.root.join('imports/updated_spruill_products.csv')

downcase_converter = ->(header) { header.downcase }
table = CSV.parse(File.read(path), headers: true, header_converters: downcase_converter)

table.each do |row|
  part = Part.find_by(sku: row['sku'])

  next if part.blank?

  part.update(description: row['new description'])
end
