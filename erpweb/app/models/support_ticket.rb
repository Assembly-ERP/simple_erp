# frozen_string_literal: true

# app/models/support_ticket.rb
class SupportTicket < ApplicationRecord
  belongs_to :customer
  belongs_to :user, optional: true
  has_many :support_ticket_messages, class_name: 'SupportTicketMessage', dependent: :destroy

  validates :issue_description, :title, :status, presence: true
  enum status: { open: 0, resolved: 1, pending: 2 }
end
