# frozen_string_literal: true

require 'csv'

class CustomerImportJob
  include Sidekiq::Job

  def perform(import_id)
    import = CustomerImport.find(import_id)
    logger_path = Rails.root.join("log/customer_imports/customer_import_#{import_id}.log")
    logger = Logger.new(logger_path)

    downcase_converter = ->(header) { header.downcase }
    table = CSV.parse(import.sheet.download, headers: true, header_converters: downcase_converter)

    import.update_attribute(:total_rows, table.count)

    table.each do |row|
      name = row['customer']
      ein = row['ein']
      phone = row['phone']
      street = row['street']
      city = row['city']
      state = row['state']
      zip_code = row['zip_code']

      customer_import = Customer.build(
        name:, ein:, phone:, street:,
        city:, state:, postal_code: zip_code
      )

      if customer_import.valid?
        customer_import.save!
        logger.info "Created customer: #{customer_import.name}"
      else
        logger.warn "Failed to create customer: #{customer_import.errors.full_messages.join(', ')}"
      end
    end

    import.update_attribute(:status, 'success')
    import.update!(log: File.open(logger_path, filename: "customer_import_#{import_id}_log"))
    File.delete(logger_path)

    Turbo::StreamsChannel.broadcast_render_to(
      :import_upload_list,
      template: 'operational_portal/customer_imports/update',
      locals: { ci: import }
    )
  end
end
