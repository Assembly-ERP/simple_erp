# frozen_string_literal: true

# app/queries/support_ticket_query.rb
class SupportTicketQuery
  def initialize(relation = SupportTicket.all)
    @relation = relation
  end

  def all_tickets_with_associations
    @relation.includes(:customer, :user, support_ticket_messages: { file_attachment: :blob })
  end
end
