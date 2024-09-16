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
  scope :sort_asc, -> { order(id: :asc) }
  scope :sort_desc, -> { order(id: :desc) }
  scope :not_voided, -> { where(voided_at: nil) }
  scope :with_order_status,
        lambda {
          select('orders.*, order_statuses.name AS status')
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
  before_save :format_id, if: :new_record?
  before_save :calculate_total_amount_before, if: :calculate_total_amount_condition?
  after_save :send_quote_or_invoice, if: :send_quote_or_invoice_condition?

  def calculate_total_amount
    base_price, total_amount = price_calculation

    update_column(:price, base_price)
    update_column(:total_amount, total_amount)
  end

  def price_calculation
    base_price = order_details.map { |od| od.price.to_f * od.quantity.to_i }.sum
    discount_amount = base_price.to_f * (discount_percentage.to_f / 100).to_f
    total_amount = base_price.to_f - discount_amount.to_f + shipping_price.to_f + tax.to_f

    [base_price, total_amount]
  end

  def self.recalculate_price
    active_scheduler = OrderPriceScheduler.find_by(active: true)
    return if active_scheduler.blank?

    case active_scheduler.code
    when 'PER_MONTH'
      Order.per_month_scheduler
    end
  end

  def self.per_month_scheduler
    orders = Order.joins(:order_status)
                  .where(voided_at: nil, order_status: { customer_locked: false })
                  .where('orders.last_scheduled <=?', 1.month.ago)

    orders.each do |order|
      order.order_details.map(&:calculate_price)
      order.calculate_total_amount
      order.update_column(:last_scheduled, Time.zone.now)
    end
  end

  def self.latest_yearly_holder
    where('extract(year from created_at) = ?',
          Time.zone.now.year).maximum(:holder_id)
  end

  private

  def format_id
    case OrderIdFormat.active_format&.format
    when 'yearly'
      self.holder_id = (Order.latest_yearly_holder || 0) + 1
      self.formatted_id = "#{Time.zone.now.year}-#{format('%04d', holder_id)}"
    else
      self.holder_id = id
      self.formatted_id = id
    end
  end

  def calculate_total_amount_before
    base_price, total_amount = price_calculation

    self.price = base_price
    self.total_amount = total_amount
  end

  def calculate_total_amount_condition?
    new_record? || !order_status.customer_locked
  end

  def send_quote_or_invoice_condition?
    send_quote_assignees && (total_amount_previously_changed? || order_status_previously_changed?)
  end

  def send_quote_or_invoice
    return if users.count.zero?

    OrderMailer.send_quote_or_invoice(self).deliver_later
  end
end

# == Schema Information
#
# Table name: orders
#
#  id                   :bigint           not null, primary key
#  discount_percentage  :decimal(5, 2)    default(0.0)
#  last_scheduled       :datetime
#  price                :decimal(10, 2)   default(0.0)
#  send_quote_assignees :boolean          default(TRUE), not null
#  shipping_price       :decimal(10, 2)   default(0.0)
#  tax                  :decimal(10, 2)   default(0.0)
#  total_amount         :decimal(10, 2)   default(0.0)
#  voided_at            :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  customer_id          :bigint           not null
#  formatted_id         :string           not null
#  holder_id            :integer
#  order_status_id      :bigint           not null
#
# Indexes
#
#  index_orders_on_customer_id      (customer_id)
#  index_orders_on_formatted_id     (formatted_id) UNIQUE
#  index_orders_on_last_scheduled   (last_scheduled)
#  index_orders_on_order_status_id  (order_status_id)
#  index_orders_on_voided_at        (voided_at)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (order_status_id => order_statuses.id)
#
