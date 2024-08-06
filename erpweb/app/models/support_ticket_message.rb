# frozen_string_literal: true

# app/models/support_ticket_message.rb
class SupportTicketMessage < ApplicationRecord
  belongs_to :support_ticket
  belongs_to :user
  has_many_attached :files

  validates :body, presence: true
end
