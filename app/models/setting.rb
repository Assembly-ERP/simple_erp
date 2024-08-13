# frozen_string_literal: true

class Setting < ApplicationRecord
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true

  after_save :recalculate_part_prices, if: -> { key == 'Price Per Pound' && saved_change_to_value? }

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

# == Schema Information
#
# Table name: settings
#
#  id         :bigint           not null, primary key
#  key        :string           not null
#  value      :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_settings_on_key  (key) UNIQUE
#
