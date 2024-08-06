# frozen_string_literal: true

# app/models/setting.rb
class Setting < ApplicationRecord
  after_save :recalculate_part_prices, if: -> { key == 'Price Per Pound' && saved_change_to_value? }

  validates :key, presence: true, uniqueness: true
  validates :value, presence: true

  def self.get(key)
    find_by(key:)&.value
  end

  def self.set(key, value)
    setting = find_or_initialize_by(key:)
    setting.value = value
    setting.save!
  end

  def self.price_per_pound
    find_by(key: 'Price Per Pound')&.value.to_f
  end

  private

  def recalculate_part_prices
    Part.where(manual_price: false).find_each do |part|
      part.update(price: part.calculate_price)
    end
  end
end
