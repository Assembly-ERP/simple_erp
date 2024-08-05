# app/models/customer.rb
class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :support_tickets, dependent: :destroy
  has_many :users, class_name: 'CustomerUser'

  validates :name, presence: true
  validates :phone, presence: true
  validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  # Remove Typesense-related callbacks
  # after_create_commit { broadcast_append_to "customer_channel" }
  # after_commit :index_document_in_typesense

  # Remove Typesense-related methods
  # def index_document_in_typesense
  #   document = customer_document(self)
  #   Rails.logger.debug "Upserting document to Typesense: #{document.inspect}"
  #   upsert_document('customers', document)
  # end

 # private

  # Remove Typesense-related methods
  # def customer_document(customer)
  #   {
  #     id: customer.id.to_s,
  #     name: customer.name,
  #     phone: customer.phone,
  #     street: customer.street,
  #     city: customer.city,
  #     state: customer.state,
  #     postal_code: customer.postal_code,
  #     discount: customer.discount.to_f # Ensure discount is a float
  #   }
  # end

  # def upsert_document(collection_name, document)
  #   begin
  #     TYPESENSE_CLIENT.collections[collection_name].documents[document[:id]].delete
  #   rescue Typesense::Error::ObjectNotFound
  #     # Ignore if the document doesn't exist
  #   end
  #   TYPESENSE_CLIENT.collections[collection_name].documents.create(document)
  # end
end
