# frozen_string_literal: true

class Product < ApplicationRecord
  # Relationships
  has_many :parts_products, dependent: :destroy
  has_many :parts, through: :parts_products
  has_many :poly_attributes, as: :attributable, dependent: :destroy

  accepts_nested_attributes_for :parts_products, allow_destroy: true

  # Validations
  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0, only_float: true }

  # Generators
  before_save :calculate_weight

  def parts_with_quantities
    parts_products.includes(:part).to_h { |pp| [pp.part, pp.quantity] }
  end

  def price
    parts_products.sum { |pp| pp.part.price.to_f * pp.quantity.to_i }
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

# == Schema Information
#
# Table name: products
#
#  id              :bigint           not null, primary key
#  description     :text
#  json_attributes :json
#  name            :string
#  price           :decimal(10, 2)
#  weight          :decimal(10, 2)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
