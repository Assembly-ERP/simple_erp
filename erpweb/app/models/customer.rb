# frozen_string_literal: true

# app/models/customer.rb
class Customer < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :support_tickets, dependent: :destroy
  has_many :users, class_name: 'CustomerUser', dependent: :destroy

  validates :name, presence: true
  validates :phone, presence: true
  validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end

# == Schema Information
#
# Table name: customers
#
#  id          :bigint           not null, primary key
#  address     :string
#  city        :string
#  discount    :decimal(5, 2)    default(0.0)
#  name        :string
#  phone       :string
#  postal_code :string
#  state       :string
#  street      :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
