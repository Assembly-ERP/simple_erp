# frozen_string_literal: true

class Product < ApplicationRecord
  # Relationships
  has_many :parts_products, dependent: :destroy
  has_many :parts, through: :parts_products
  has_many :order_details, dependent: :destroy
  has_many :poly_attributes, as: :attributable, dependent: :destroy

  accepts_nested_attributes_for :parts_products, allow_destroy: true

  # Attachments
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [320, 320]
  end

  # Scopes
  scope :search_results, lambda {
    select("products.id, products.name, products.price, products.weight, 'product' AS type")
  }
  scope :catalog, lambda {
    select('products.id, products.name, products.description, products.price, products.weight, ' \
           "'product' AS type, 0 AS in_stock, products.created_at, products.available, " \
           'FALSE as inventory')
  }
  scope :search_results_with_order, lambda { |order_id|
    select('order_details.id AS item_id, order_details.quantity AS quantity')
      .joins("LEFT JOIN order_details ON order_details.order_id = #{order_id} " \
             'AND order_details.product_id = products.id')
  }

  # Validations
  validates :name, presence: true
  # validates :parts_products, presence: { message: 'add at least one part' }
  validates :price, numericality: { greater_than_or_equal_to: 0, only_float: true }

  # Generators
  after_save :calculate_weight
  after_save :calculate_price
  after_save :update_availability

  private

  def calculate_price
    update_column(:price, parts_products.map { |pp| pp.quantity * pp.part.price }.sum)
  end

  def calculate_weight
    update_column(:weight, parts_products.map { |pp| pp.quantity * pp.part.weight }.sum)
  end

  def update_availability
    inventory_parts = parts.where(inventory: true)

    if inventory_parts.count.zero?
      update_column(:available, true)
      return
    end

    if inventory_parts.where('in_stock = 0').count.positive?
      update_column(:available, false)
      return
    end

    update_column(:available, true)
  end
end

# == Schema Information
#
# Table name: products
#
#  id              :bigint           not null, primary key
#  available       :boolean          default(FALSE), not null
#  description     :text
#  json_attributes :json
#  name            :string           not null
#  price           :decimal(10, 2)   default(0.0)
#  sku             :string
#  weight          :decimal(10, 2)   default(0.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
