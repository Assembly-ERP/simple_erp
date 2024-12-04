# frozen_string_literal: true

class Order < ApplicationRecord
  include OrderCalculable
  include OrderMailable
  include OrderCronable
  include OrderFormattable

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
  scope :with_order_status, -> { select('orders.*, order_statuses.name AS status').joins(:order_status) }
  scope :with_customer, -> { select('orders.*, customers.name as customer_name').joins(:customer) }

  # Validations
  validates :total_amount, numericality: { greater_than_or_equal_to: 0, only_float: true }
  validates :price, numericality: { greater_than_or_equal_to: 0, only_float: true }
  validates :tax, numericality: { greater_than_or_equal_to: 0, only_float: true }
  validates :order_details, presence: { message: I18n.t('errors.orders.order_details_present') }
  validates :discount_percentage, numericality: {
    greater_than_or_equal_to: 0, less_than_or_equal_to: 100, only_float: true
  }
end

# == Schema Information
#
# Table name: orders
#
#  id                   :bigint           not null, primary key
#  discount_percentage  :decimal(5, 2)    default(0.0)
#  internal_note        :text
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
