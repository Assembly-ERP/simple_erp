# frozen_string_literal: true

# app/models/parts.rb
class Part < ApplicationRecord
  has_many :parts_products, dependent: :destroy
  has_many :products, through: :parts_products
  has_many_attached :files

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :weight, numericality: { greater_than_or_equal_to: 0 }

  attribute :manual_price, :boolean, default: false
  attribute :inventory, :boolean, default: false

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
#  in_stock        :integer
#  inventory       :boolean          default(FALSE), not null
#  json_attributes :json
#  manual_price    :boolean          default(FALSE), not null
#  name            :string
#  price           :decimal(10, 2)
#  weight          :decimal(10, 2)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#