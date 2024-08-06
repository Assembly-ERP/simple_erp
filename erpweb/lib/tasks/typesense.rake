# frozen_string_literal: true

# lib/tasks/typesense.rake

namespace :typesense do
  desc 'Reindex all models in Typesense'
  task reindex: :environment do
    Customer.find_each do |customer|
      document = {
        id: customer.id.to_s,
        name: customer.name.to_s,
        phone: customer.phone.to_s,
        street: customer.street.to_s,
        city: customer.city.to_s,
        state: customer.state.to_s,
        postal_code: customer.postal_code.to_s,
        discount: customer.discount.to_f
      }

      upsert_document('customers', document)
    end

    puts 'Reindexing completed'
  end
end
