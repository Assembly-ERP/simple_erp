# frozen_string_literal: true

class Product < ApplicationRecord
  # Constants
  ALLOWED_IMAGE_TYPES = %w[image/png image/jpg image/jpeg].freeze

  # Relationships
  has_many :parts_products, dependent: :destroy
  has_many :parts, through: :parts_products
  has_many :order_details, dependent: :destroy
  has_many :poly_attributes, as: :attributable, dependent: :destroy

  accepts_nested_attributes_for :parts_products, allow_destroy: true
  accepts_nested_attributes_for :poly_attributes, allow_destroy: true, reject_if: :all_blank

  # Attachments
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [320, 320]
  end

  # Scopes
  scope :sort_newest, -> { order(created_at: :desc) }
  scope :sort_oldest, -> { order(created_at: :asc) }
  scope :not_voided, -> { where(voided_at: nil) }
  scope :category_filter, lambda {
    select('products.category, count(products.category) as category_count')
      .group(:category).order(category: :asc)
  }
  scope :search_results, lambda {
    select("products.id, products.name, products.price, products.weight, products.sku, 'product' AS type," \
           'products.created_at')
  }
  scope :catalog, lambda {
    select('products.id, products.name, products.description, products.price, products.weight, products.sku, ' \
           "'product' AS type, 0 AS in_stock, products.created_at, products.available, products.category, " \
           'FALSE as inventory')
  }
  scope :search_results_with_order, lambda { |order_id|
    select('order_details.id AS item_id, order_details.quantity AS quantity')
      .joins("LEFT JOIN order_details ON order_details.order_id = #{order_id} " \
             'AND order_details.product_id = products.id')
  }

  # Validations
  validates :name, presence: true
  validates :images, content_type: ALLOWED_IMAGE_TYPES
  validates :price, numericality: { greater_than_or_equal_to: 0, only_float: true }
  # validates :parts_products, presence: { message: 'add at least one part' }
  validates :sku, uniqueness: { allow_blank: true, conditions: lambda {
    where("sku IS NOT NULL AND sku != '' AND voided_at IS NULL")
  } }

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
#  id          :bigint           not null, primary key
#  available   :boolean          default(FALSE), not null
#  category    :string
#  description :text
#  name        :string           not null
#  nmfc        :string
#  price       :decimal(10, 2)   default(0.0)
#  sku         :string
#  voided_at   :datetime
#  weight      :decimal(10, 2)   default(0.0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_products_on_name       (name)
#  index_products_on_sku        (sku) UNIQUE WHERE ((sku IS NOT NULL) AND ((sku)::text <> ''::text) AND (voided_at IS NULL))
#  index_products_on_voided_at  (voided_at)
#
