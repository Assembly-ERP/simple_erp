# frozen_string_literal: true

class Setting < ApplicationRecord
  # Validations
  validates :key, presence: true, uniqueness: true
  validates :value, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0, only_float: true }

  # Generators
  after_save :recalculate_part_price, if: :value_previously_changed?

  def self.active_pricing
    find_by(active: true)&.value.to_f
  end

  private

  def recalculate_part_price
    Part.where(manual_price: false).find_each do |part|
      part.update(updated_at: Time.zone.now)
    end
  end
end

# == Schema Information
#
# Table name: settings
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(FALSE), not null
#  code       :string           not null
#  key        :string           not null
#  value      :decimal(10, 2)   default(0.0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_settings_on_key_and_code  (key,code) UNIQUE
#
