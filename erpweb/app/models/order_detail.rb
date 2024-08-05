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
    errors.add(:base, "Must have either a product or a part") unless product_id.present? ^ part_id.present?
  end
end