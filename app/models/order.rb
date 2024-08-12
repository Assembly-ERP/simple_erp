# frozen_string_literal: true

# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  has_many :parts, through: :order_details

  accepts_nested_attributes_for :order_details, allow_destroy: true

  validates :status, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validate :at_least_one_item, on: :create

  enum status: { pre_order: 'pre-order', created: 'new', submitted: 'submitted', cancelled: 'cancelled' }

  before_save :calculate_total_amount
  before_create :set_default_status

  def total_amount
    order_details.sum(&:subtotal)
  end

  private

  def at_least_one_item
    return unless order_details.empty?

    errors.add(:base, 'Order must have at least one item')
  end

  def calculate_total_amount
    # self.total_amount = total_amount
    self.total_amount = order_details.sum(&:subtotal)
  end

  def set_default_status
    self.status ||= 'new'
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