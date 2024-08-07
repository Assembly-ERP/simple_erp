# frozen_string_literal: true

# spec/models/support_ticket_spec.rb
require 'rails_helper'

RSpec.describe SupportTicket, type: :model do
  it 'is valid with valid attributes' do
    ticket = SupportTicket.new(issue_description: 'Issue description', status: 'open', customer: create(:customer))
    expect(ticket).to be_valid
  end

  it 'is not valid without an issue_description' do
    ticket = SupportTicket.new(issue_description: nil)
    expect(ticket).not_to be_valid
  end

  it 'is not valid without a status' do
    ticket = SupportTicket.new(status: nil)
    expect(ticket).not_to be_valid
  end

  it 'is not valid without a customer' do
    ticket = SupportTicket.new(customer: nil)
    expect(ticket).not_to be_valid
  end
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
