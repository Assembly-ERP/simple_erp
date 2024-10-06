# frozen_string_literal: true

if ENV['USER_IMPORT_FILE'].present?
  require 'csv'

  path = Rails.root.join("imports/#{ENV['USER_IMPORT_FILE']}")

  downcase_converter = ->(header) { header.downcase }
  table = CSV.parse(File.read(path), headers: true, header_converters: downcase_converter)

  table.each do |row|
    if row['type'] == 'part'
      part = Part.build(
        name: row['sku'],
        sku: row['sku'],
        description: row['new description'],
        nmfc: row['nmfc'],
        category: row['category'],
        width: row['width']&.chomp('"').to_f || 0,
        weight: row['weight']&.chomp('lbs').to_f || 0,
        length: row['length']&.chomp('"').to_f || 0
      )

      next unless part.valid?

      part.save!
      part.poly_attributes.create(input_type: 'text', value: row['gauge'], label: 'Gauge') if row['gauge'].present?
      part.poly_attributes.create(input_type: 'text', value: row['depth'], label: 'Depth') if row['depth'].present?
      part.poly_attributes.create(input_type: 'text', value: row['gcode'], label: 'GCODE') if row['gcode'].present?
      part.poly_attributes.create(input_type: 'text', value: row['height'], label: 'Height') if row['height'].present?
      if row['capacity'].present?
        part.poly_attributes.create(input_type: 'text', value: row['capacity'],
                                    label: 'Capacity')
      end
    else
      product = Product.build(
        name: row['sku'],
        sku: row['sku'],
        description: row['new description'],
        nmfc: row['nmfc'],
        category: row['category'],
        weight: row['weight']&.chomp('lbs').to_f || 0
      )

      next unless product.valid?

      product.save!
      product.poly_attributes.create(input_type: 'text', value: row['gauge'], label: 'Gauge') if row['gauge'].present?
      product.poly_attributes.create(input_type: 'text', value: row['gcode'], label: 'GCODE') if row['gcode'].present?
      if row['height'].present?
        product.poly_attributes.create(input_type: 'text', value: row['height'],
                                       label: 'Height')
      end
    end
  end
end
