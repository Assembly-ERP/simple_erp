#app/models/order.rb
class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  has_many :parts, through: :order_details

  accepts_nested_attributes_for :order_details, allow_destroy: true

  validates :status, presence: true
  validates :customer, presence: true
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
  validate :at_least_one_item, on: :create

  enum status: { pre_order: 'pre-order', created: 'new', submitted: 'submitted', cancelled: 'cancelled' }

  before_save :calculate_total_amount
  before_create :set_default_status

  def total_amount
    order_details.sum(&:subtotal)
    # amount = read_attribute(:total_amount)
    # amount.nil? ? 0.00 : amount.to_f
  end

  private

  def at_least_one_item
    if order_details.empty?
      errors.add(:base, "Order must have at least one item")
    end
  end

  def calculate_total_amount
    # self.total_amount = total_amount
    self.total_amount = order_details.sum(&:subtotal)
  end

  def set_default_status
    self.status ||= 'new'
  end
end