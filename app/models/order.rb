# frozen_string_literal: true

class Order < ApplicationRecord
  # Constants
  STATUSES = %w[pre-order new submitted cancelled].freeze

  # Relationships
  belongs_to :customer

  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  has_many :parts, through: :order_details
  has_many :poly_attributes, as: :attributable, dependent: :destroy

  accepts_nested_attributes_for :order_details, allow_destroy: true

  # Scopes
  scope :with_customer,
        lambda {
          select('orders.*, customers.name as customer_name')
            .joins(:customer)
        }

  # Validations
  validates :status, inclusion: { in: STATUSES }, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0, only_float: true }
  validates :order_details, presence: { message: 'must have at least one item' }

  # Generators
  before_validation :set_default_status
  before_validation :calculate_total_amount, if: :new_record?

  private

  def calculate_total_amount
    self.total_amount = order_details.map { |od| od.item_price.to_f * od.quantity.to_i }.sum
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
