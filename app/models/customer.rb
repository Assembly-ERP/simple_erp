# frozen_string_literal: true

class Customer < ApplicationRecord
  # Relationships
  has_many :orders, dependent: :destroy
  has_many :support_tickets, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :poly_attributes, as: :attributable, dependent: :destroy

  # Scopes
  scope :sort_asc, -> { order(id: :asc) }
  scope :sort_desc, -> { order(id: :desc) }
  scope :not_voided, -> { where(voided_at: nil) }

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :discount, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end

# == Schema Information
#
# Table name: customers
#
#  id          :bigint           not null, primary key
#  city        :string
#  discount    :decimal(5, 2)    default(0.0)
#  ein         :string
#  name        :string           not null
#  phone       :string
#  postal_code :string
#  state       :string
#  street      :string
#  voided_at   :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_customers_on_name  (name) UNIQUE
#
