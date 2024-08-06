# frozen_string_literal: true

# spec/controllers/operational_portal/support_tickets_controller_spec.rb
require 'rails_helper'

RSpec.describe OperationalPortal::SupportTicketsController, type: :controller do
  let(:admin_user) { create(:user, role: 'admin') }
  let(:manager_user) { create(:user, role: 'manager') }
  let(:customer) { create(:customer) }
  let(:support_ticket) { create(:support_ticket, customer:, user: admin_user) }

  before do
    sign_in admin_user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: support_ticket.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    it 'creates a new SupportTicket' do
      expect do
        post :create,
             params: { support_ticket: { title: 'New Ticket', issue_description: 'Description', status: 'open',
                                         customer_id: customer.id } }
      end.to change(SupportTicket, :count).by(1)
    end
  end
end
