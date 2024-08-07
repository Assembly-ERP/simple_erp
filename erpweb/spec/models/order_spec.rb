# frozen_string_literal: true

# spec/models/order_spec.rb
require 'rails_helper'

RSpec.describe Order, type: :model do
  it 'is valid with valid attributes' do
    order = Order.new(status: 'pending', total: 100.0, customer: create(:customer))
    expect(order).to be_valid
  end

  it 'is not valid without a status' do
    order = Order.new(status: nil)
    expect(order).not_to be_valid
  end

  it 'is not valid without a total' do
    order = Order.new(total: nil)
    expect(order).not_to be_valid
  end

  it 'is not valid without a customer' do
    order = Order.new(customer: nil)
    expect(order).not_to be_valid
  end
end

# == Schema Information
#
# Table name: orders
#
#  id           :bigint           not null, primary key
#  status       :string
#  total_amount :decimal(, )
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  customer_id  :bigint           not null
#
# Indexes
#
#  index_orders_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
