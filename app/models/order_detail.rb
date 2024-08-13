# frozen_string_literal: true

class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product, optional: true
  belongs_to :part, optional: true

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validate :product_or_part_present

  def item_price
    (product&.price || part&.price || 0).to_f
  end

  def subtotal
    quantity * item_price
  end

  private

  def product_or_part_present
    errors.add(:order, 'must have either a product or a part') unless product_id.present? || part_id.present?
  end
end

# == Schema Information
#
# Table name: order_details
#
#  id         :bigint           not null, primary key
#  price      :decimal(10, 2)
#  quantity   :integer
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
