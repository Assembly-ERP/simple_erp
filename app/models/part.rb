# frozen_string_literal: true

class Part < ApplicationRecord
  # Constants
  ALLOWED_IMAGE_TYPES = %w[image/png image/jpg image/jpeg].freeze

  # Relationships
  has_many :parts_products, dependent: :destroy
  has_many :products, through: :parts_products
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details
  has_many :poly_attributes, as: :attributable, dependent: :destroy

  accepts_nested_attributes_for :poly_attributes, allow_destroy: true, reject_if: :all_blank

  # Attachments
  has_many_attached :files
  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [320, 320]
  end

  # Scopes
  scope :sort_newest, -> { order(created_at: :desc) }
  scope :sort_oldest, -> { order(created_at: :asc) }
  scope :not_voided, -> { where(voided_at: nil) }
  scope :category_filter, lambda {
    select('parts.category, count(category) as category_count')
      .group(:category).order(category: :asc)
  }
  scope :search_results, lambda {
    select("parts.id, parts.name, parts.price, parts.weight, parts.sku, 'part' AS type," \
           'parts.created_at')
  }
  scope :catalog, lambda {
    select('parts.id, parts.name, parts.description, parts.price, parts.weight, parts.sku, ' \
           "'part' AS type, parts.in_stock, parts.created_at, FALSE AS available, parts.category, " \
           'parts.inventory')
  }
  scope :search_results_with_order, lambda { |order_id|
    select('order_details.id AS item_id, order_details.quantity AS quantity')
      .joins("LEFT JOIN order_details ON order_details.order_id = #{order_id} " \
             'AND order_details.part_id = parts.id')
  }
  scope :with_product,
        lambda { |product_id|
          select('parts.*, parts_products.product_id AS product_id, parts_products.quantity AS quantity, ' \
                 'parts_products.id AS item_id')
            .joins("LEFT JOIN parts_products ON parts_products.product_id = #{product_id} " \
                   'AND parts_products.part_id = parts.id')
        }

  # Validations
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0, only_float: true, message: 'must be equal or greater than zero' }
  validates :weight, numericality: { greater_than_or_equal_to: 0, message: 'must be equal or greater than zero' }
  validates :images, content_type: ALLOWED_IMAGE_TYPES
  validates :sku, uniqueness: { allow_blank: true, conditions: lambda {
    where("sku IS NOT NULL AND sku != '' AND voided_at IS NULL")
  } }

  # Generators
  before_validation :set_price_value, unless: :manual_price?
  after_save :recalculate_products, if: :recalculate_products_condition?

  private

  def calculate_price
    price_per_pound = Setting.active_pricing
    weight.to_f * price_per_pound
  end

  def recalculate_products
    products.each do |product|
      product.update(updated_at: Time.zone.now)
    end
  end

  def recalculate_products_condition?
    price_previously_changed? || in_stock_previously_changed? || inventory_previously_changed? ||
      updated_at_previously_changed?
  end

  def set_price_value
    self.price = calculate_price
  end
end

# == Schema Information
#
# Table name: parts
#
#  id           :bigint           not null, primary key
#  category     :string
#  description  :text
#  in_stock     :integer          default(0)
#  inventory    :boolean          default(FALSE), not null
#  length       :decimal(10, 2)   default(0.0)
#  manual_price :boolean          default(FALSE), not null
#  name         :string           not null
#  nmfc         :string
#  price        :decimal(10, 2)   default(0.0)
#  sku          :string
#  voided_at    :datetime
#  weight       :decimal(10, 2)   default(0.0)
#  width        :decimal(10, 2)   default(0.0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_parts_on_name       (name)
#  index_parts_on_sku        (sku) UNIQUE WHERE ((sku IS NOT NULL) AND ((sku)::text <> ''::text) AND (voided_at IS NULL))
#  index_parts_on_voided_at  (voided_at)
#
