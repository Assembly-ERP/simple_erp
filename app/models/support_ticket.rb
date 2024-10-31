# frozen_string_literal: true

class SupportTicket < ApplicationRecord
  # Constants
  STATUSES = %w[open waiting_for_support waiting_for_customer closed resolved].freeze

  # Attachments
  has_many_attached :files

  # Relationships
  belongs_to :customer, optional: true
  belongs_to :user

  has_many :support_ticket_messages, dependent: :destroy

  # Scopes
  scope :with_customer, -> { select('support_tickets.*, customers.name as customer_name').joins(:customer) }

  # Validations
  validates :issue_description, :title, :status, presence: true
  validates :status, inclusion: { in: STATUSES }, presence: true

  # Custom Validations
  validate :user_must_under_customer

  private

  def user_must_under_customer
    return unless customer_id.present? && (user_id_changed? || customer_id_changed?) && user.customer.id != customer.id

    errors.add(:user, 'must be under customer')
  end
end

# == Schema Information
#
# Table name: support_tickets
#
#  id                :bigint           not null, primary key
#  issue_description :text             not null
#  status            :string           default("pending"), not null
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  customer_id       :bigint
#  user_id           :bigint           not null
#
# Indexes
#
#  index_support_tickets_on_customer_id  (customer_id)
#  index_support_tickets_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (user_id => users.id)
#
