# frozen_string_literal: true

class Part < ApplicationRecord
  # Relationships
  has_many :parts_products, dependent: :destroy
  has_many :products, through: :parts_products
  has_many :poly_attributes, as: :attributable, dependent: :destroy

  # Attachments
  has_many_attached :files

  # Scopes
  default_scope { order(id: :desc) }

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

  def calculate_price
    price_per_pound = Setting.price_per_pound
    weight.to_f * price_per_pound
  end

  private

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
