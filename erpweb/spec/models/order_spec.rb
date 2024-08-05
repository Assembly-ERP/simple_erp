# spec/models/order_spec.rb
require 'rails_helper'

RSpec.describe Order, type: :model do
  it "is valid with valid attributes" do
    order = Order.new(status: "pending", total: 100.0, customer: create(:customer))
    expect(order).to be_valid
  end

  it "is not valid without a status" do
    order = Order.new(status: nil)
    expect(order).not_to be_valid
  end

  it "is not valid without a total" do
    order = Order.new(total: nil)
    expect(order).not_to be_valid
  end

  it "is not valid without a customer" do
    order = Order.new(customer: nil)
    expect(order).not_to be_valid
  end
end
