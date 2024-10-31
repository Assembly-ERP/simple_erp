# frozen_string_literal: true

class SupportTicketMessage < ApplicationRecord
  # Attachments
  has_many_attached :files

  # Relationships
  belongs_to :support_ticket
  belongs_to :user

  # Scopes
  default_scope { order(id: :asc) }

  validates :body, presence: true

  after_commit :add_stream_messages, on: :create

  def add_stream_messages
    Turbo::StreamsChannel.broadcast_render_to(
      "support_ticket_#{support_ticket.id}",
      template: 'operational_portal/support_tickets/add_message_stream',
      locals: { support_ticket_message: self, support_ticket: }
    )
  end
end

# == Schema Information
#
# Table name: support_ticket_messages
#
#  id                :bigint           not null, primary key
#  body              :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  support_ticket_id :bigint           not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_support_ticket_messages_on_support_ticket_id  (support_ticket_id)
#  index_support_ticket_messages_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (support_ticket_id => support_tickets.id)
#  fk_rails_...  (user_id => users.id)
#
