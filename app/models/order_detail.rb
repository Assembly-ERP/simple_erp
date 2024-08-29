# frozen_string_literal: true

class OrderDetail < ApplicationRecord
  # Relationships
  belongs_to :order, touch: true
  belongs_to :product, optional: true
  belongs_to :part, optional: true

  scope :with_part_and_product, lambda {
    select('order_details.*, products.name AS product_name, parts.name AS part_name, ' \
           'parts.price AS part_price, products.price AS product_price')
      .joins('LEFT JOIN products ON order_details.product_id = products.id')
      .joins('LEFT JOIN parts ON order_details.part_id = parts.id')
  }

  # Validations
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0, only_float: true }
  validate :product_or_part_present

  # Generators
  # after_save :calculate_price, unless: :override?

  def subtotal
    quantity * price
  end

  private

  # def calculate_price
  #   update_column(:price, product&.price || part&.price || 0.0)
  # end

  def product_or_part_present
    errors.add(:order, I18n.t('errors.order_details.product_or_part')) unless product_id.present? || part_id.present?
  end
end

# == Schema Information
#
# Table name: order_details
#
#  id         :bigint           not null, primary key
#  override   :boolean          default(FALSE), not null
#  price      :decimal(10, 2)   default(0.0)
#  quantity   :integer          default(1), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  order_id   :bigint           not null
#  part_id    :bigint
#  product_id :bigint
#
# Indexes
#
#  index_order_details_on_order_id    (order_id)
#  index_order_details_on_part_id     (part_id)
#  index_order_details_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (part_id => parts.id)
#  fk_rails_...  (product_id => products.id)
#
