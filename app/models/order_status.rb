# frozen_string_literal: true

class OrderStatus < ApplicationRecord
  # Relations
  has_many :orders, dependent: :destroy

  # Validations
  validate :only_on_locked_reversed

  def self.default_id
    find_by(default: true)&.id
  end

  private

  def only_on_locked_reversed
    return unless !locked && reversed

    errors.add(:reversed, 'must be allong with locked')
  end
end

# == Schema Information
#
# Table name: order_statuses
#
#  id         :bigint           not null, primary key
#  default    :boolean          default(FALSE), not null
#  locked     :boolean          default(FALSE), not null
#  name       :string           not null
#  reversed   :boolean          default(FALSE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
