# frozen_string_literal: true

# app/models/support_ticket.rb
class SupportTicket < ApplicationRecord
  belongs_to :customer
  belongs_to :user, optional: true
  has_many :support_ticket_messages, class_name: 'SupportTicketMessage', dependent: :destroy

  validates :issue_description, :title, :status, presence: true
  enum status: { open: 0, resolved: 1, pending: 2 }
end

# == Schema Information
#
# Table name: support_tickets
#
#  id                :bigint           not null, primary key
#  issue_description :text
#  status            :string
#  title             :string
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
