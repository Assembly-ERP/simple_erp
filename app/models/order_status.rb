# frozen_string_literal: true

class OrderStatus < ApplicationRecord
  # Relations
  has_many :orders, dependent: :destroy

  # Validations
  validate :only_on_locked_reversed
  validate :operation_always_customer_locked

  def self.default_id
    find_by(default: true)&.id
  end

  def self.cancel_status
    find_by(name: 'Cancelled')
  end

  private

  def only_on_locked_reversed
    return unless !operation_locked && reversed

    errors.add(:reversed, 'must be along with operation locked')
  end

  def operation_always_customer_locked
    return unless operation_locked && !customer_locked

    errors.add(:operation_locked, 'must be along with customer locked')
  end
end

# == Schema Information
#
# Table name: order_statuses
#
#  id               :bigint           not null, primary key
#  customer_locked  :boolean          default(FALSE), not null
#  default          :boolean          default(FALSE), not null
#  name             :string           not null
#  operation_locked :boolean          default(FALSE), not null
#  reversed         :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
