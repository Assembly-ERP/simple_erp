# frozen_string_literal: true

class Order < ApplicationRecord
  # Relationships
  belongs_to :customer
  belongs_to :order_status

  has_one :order_shipping_address, dependent: :destroy
  has_many :order_assignees, dependent: :destroy
  has_many :users, through: :order_assignees
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  has_many :parts, through: :order_details
  has_many :poly_attributes, as: :attributable, dependent: :destroy

  accepts_nested_attributes_for :order_details, allow_destroy: true
  accepts_nested_attributes_for :order_shipping_address, reject_if: :all_blank

  # Scopes
  scope :not_voided, -> { where(voided_at: nil) }
  scope :with_order_status,
        lambda {
          select('orders.*, order_statuses.name AS status, order_statuses.locked AS status_locked')
            .joins(:order_status)
        }
  scope :with_customer,
        lambda {
          select('orders.*, customers.name as customer_name')
            .joins(:customer)
        }

  # Validations
  validates :total_amount, numericality: { greater_than_or_equal_to: 0, only_float: true }
  validates :price, numericality: { greater_than_or_equal_to: 0, only_float: true }
  validates :tax, numericality: { greater_than_or_equal_to: 0, only_float: true }
  validates :order_details, presence: { message: I18n.t('errors.orders.order_details_present') }
  validates :discount_percentage, numericality: {
    greater_than_or_equal_to: 0, less_than_or_equal_to: 100, only_float: true
  }

  # Generators
  after_save :calculate_total_amount, if: :calculate_total_amount_condition?

  def calculate_total_amount
    base_price = order_details.map { |od| od.price.to_f * od.quantity.to_i }.sum
    discount_amount = base_price.to_f * (discount_percentage.to_f / 100).to_f
    total_amount = base_price.to_f - discount_amount.to_f + shipping_price.to_f + tax.to_f

    update_column(:price, base_price)
    update_column(:total_amount, total_amount)
  end

  def self.recalculate_price
    current_scheduler = OrderPriceScheduler.find_by(active: true)
    return if current_scheduler.blank?

    case current_scheduler.code
    when 'PER_MONTH'
      Order.per_month_scheduler
    end
  end

  def self.per_month_scheduler
    orders = Order.joins(:order_status)
                  .where(voided_at: nil, order_status: { locked: false })
                  .where('orders.last_scheduled <=?', 1.month.ago)

    orders.each do |order|
      order.order_details.map(&:calculate_price)
      order.calculate_total_amount
      order.update_column(:last_scheduled, Time.zone.now)
    end
  end

  private

  def calculate_total_amount_condition?
    new_record? || !order_status.locked
  end
end

# == Schema Information
#
# Table name: orders
#
#  id                  :bigint           not null, primary key
#  discount_percentage :decimal(5, 2)    default(0.0)
#  last_scheduled      :datetime
#  price               :decimal(10, 2)   default(0.0)
#  shipping_price      :decimal(10, 2)   default(0.0)
#  tax                 :decimal(10, 2)   default(0.0)
#  total_amount        :decimal(10, 2)   default(0.0)
#  voided_at           :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  customer_id         :bigint           not null
#  order_status_id     :bigint           not null
#
# Indexes
#
#  index_orders_on_customer_id      (customer_id)
#  index_orders_on_order_status_id  (order_status_id)
#  index_orders_on_voided_at        (voided_at)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (order_status_id => order_statuses.id)
#
