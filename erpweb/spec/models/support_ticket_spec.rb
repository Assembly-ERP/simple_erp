# spec/models/support_ticket_spec.rb
require 'rails_helper'

RSpec.describe SupportTicket, type: :model do
  it "is valid with valid attributes" do
    ticket = SupportTicket.new(issue_description: "Issue description", status: "open", customer: create(:customer))
    expect(ticket).to be_valid
  end

  it "is not valid without an issue_description" do
    ticket = SupportTicket.new(issue_description: nil)
    expect(ticket).not_to be_valid
  end

  it "is not valid without a status" do
    ticket = SupportTicket.new(status: nil)
    expect(ticket).not_to be_valid
  end

  it "is not valid without a customer" do
    ticket = SupportTicket.new(customer: nil)
    expect(ticket).not_to be_valid
  end
end
