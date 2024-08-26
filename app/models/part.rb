# frozen_string_literal: true

class Part < ApplicationRecord
  # Relationships
  has_many :parts_products, dependent: :destroy
  has_many :products, through: :parts_products
  has_many :order_details, dependent: :destroy
  has_many :orders, through: :order_details
  has_many :poly_attributes, as: :attributable, dependent: :destroy

  # Attachments
  has_many_attached :files

  # Scopes
  scope :search_results, lambda {
    select("parts.id, parts.name, parts.price, parts.weight, 'part' AS type")
  }
  scope :for_union_with_products, lambda {
    select('parts.id, parts.name, parts.description, parts.price, parts.weight, ' \
           "'part' AS type, parts.in_stock, parts.created_at")
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
  validates :price, numericality: { greater_than_or_equal_to: 0, only_float: true }
  validates :weight, numericality: { greater_than_or_equal_to: 0 }

  # Generators
  before_validation :set_price_value, unless: :manual_price?
  after_save :recalculate_products, if: :price_previously_changed?

  private

  def calculate_price
    price_per_pound = Setting.price_per_pound
    weight.to_f * price_per_pound
  end

  def recalculate_products
    products.each do |product|
      product.update(updated_at: Time.zone.now)
    end
  end

  def set_price_value
    self.price = calculate_price
  end
end

# == Schema Information
#
# Table name: parts
#
#  id              :bigint           not null, primary key
#  description     :text
#  in_stock        :integer          default(0)
#  inventory       :boolean          default(FALSE), not null
#  json_attributes :json
#  manual_price    :boolean          default(FALSE), not null
#  name            :string           not null
#  price           :decimal(10, 2)   default(0.0)
#  weight          :decimal(10, 2)   default(0.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
