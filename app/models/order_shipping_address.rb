# frozen_string_literal: true

class OrderShippingAddress < ApplicationRecord
  belongs_to :order
end

# == Schema Information
#
# Table name: order_shipping_addresses
#
#  id         :bigint           not null, primary key
#  city       :string           default("")
#  name       :string           default("")
#  phone      :string           default("")
#  state      :string           default("")
#  street     :string           default("")
#  zip_code   :string           default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :bigint           not null
#
# Indexes
#
#  index_order_shipping_addresses_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#
