# frozen_string_literal: true

class Order < ApplicationRecord
  # Constants
  enum status: { pre_order: 'pre-order', created: 'new', submitted: 'submitted', cancelled: 'cancelled' }

  # Relationships
  belongs_to :customer
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  has_many :parts, through: :order_details

  accepts_nested_attributes_for :order_details, allow_destroy: true

  # Scopes
  scope :with_customer,
        lambda {
          select('orders.*, customers.name as customer_name')
            .joins(:customer)
        }

  # Validations
  validates :status, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validate :at_least_one_item, on: :create

  # Generators
  before_create :set_default_status
  after_save :calculate_total_amount

  private

  def at_least_one_item
    return if order_details.present?

    errors.add(:order, 'must have at least one item')
  end

  def calculate_total_amount
    # rubocop:disable Rails::SkipsModelValidations
    update_column(:total_amount, order_details.sum(&:subtotal))
    # rubocop:enable Rails::SkipsModelValidations
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
#  status       :string           not null
#  total_amount :decimal(10, 2)   default(0.0)
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
