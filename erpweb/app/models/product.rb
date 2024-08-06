# frozen_string_literal: true

# app/models/products.rb
class Product < ApplicationRecord
  has_many :parts_products, dependent: :destroy
  has_many :parts, through: :parts_products

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  before_save :calculate_weight

  def parts_with_quantities
    # parts_with_quantities = {}
    # part_quantities.each do |part_id, quantity|
    #   part = Part.find(part_id)
    #   parts_with_quantities[part] = quantity.to_i
    # end
    # parts_with_quantities

    parts_products.includes(:part).to_h { |pp| [pp.part, pp.quantity] }
  end

  def price
    # current_price = parts_products.sum { |pp| pp.part.price.to_f * pp.quantity.to_i }
    parts_products.sum { |pp| pp.part.price.to_f * pp.quantity.to_i }
    # sprintf('%.2f', current_price)
  end

  private

  def calculate_weight
    total_weight = parts_products.includes(:part).sum do |pp|
      part_weight = pp.part.weight.to_f
      quantity = pp.quantity.to_i
      part_weight * quantity
    end
    self.weight = total_weight.round(2)
  rescue StandardError => e
    Rails.logger.error "Error calculating product weight: #{e.message}"
    errors.add(:base, 'Error calculating product weight. Please check that all parts have a valid weight.')
    throw :abort
  end
end
