# frozen_string_literal: true

class Product < ApplicationRecord
  # Relationships
  has_many :parts_products, dependent: :destroy
  has_many :parts, through: :parts_products
  has_many :poly_attributes, as: :attributable, dependent: :destroy

  accepts_nested_attributes_for :parts_products, allow_destroy: true

  # Scopes
  default_scope { order(id: :desc) }

  scope :search_results, lambda {
    select("products.id, products.name, products.price, products.weight, 'product' AS type")
  }

  # Validations
  validates :name, presence: true
  validates :parts_products, presence: { message: 'add at least one part' }
  validates :price, numericality: { greater_than_or_equal_to: 0, only_float: true }

  # Generators
  before_validation :calculate_weight, if: :parts_products_is_changed?
  before_validation :calculate_price, if: :parts_products_is_changed?

  private

  def calculate_price
    self.price = parts_products.map { |pp| pp.quantity * pp.part.price }.sum
  end

  def calculate_weight
    self.weight = parts_products.map { |pp| pp.quantity * pp.part.weight }.sum
  end

  def parts_products_is_changed?
    updated_at_changed? || parts_products.any?(&:changed?)
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
#  price           :decimal(10, 2)   default(0.0)
#  weight          :decimal(10, 2)   default(0.0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
