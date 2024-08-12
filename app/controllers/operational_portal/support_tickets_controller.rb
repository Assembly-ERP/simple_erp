# frozen_string_literal: true

module OperationalPortal
  class SupportTicketsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_ticket, only: %i[show edit update destroy add_message preview_message_file]
    before_action :ensure_operational_user

    def index
      @support_tickets = SupportTicket.includes(:customer,
                                                support_ticket_messages: { files_attachments: :blob }).all ||
                         SupportTicketQuery.new.all_tickets_with_associations
    end

    def show
      @support_ticket = SupportTicket.includes(support_ticket_messages: { files_attachments: :blob }).find(params[:id])
      @new_message = SupportTicketMessage.new
    end

    def new
      @support_ticket = SupportTicket.new
      @customers = Customer.all
      @customer_users = User.customer_users
    end

    def edit
      @customers = Customer.all
      @customer_users = CustomerUser.all
    end

    def create
      @support_ticket = SupportTicket.new(support_ticket_params)
      if @support_ticket.save
        redirect_to operational_portal_support_ticket_path(@support_ticket),
                    notice: 'Support ticket was successfully created.'
      else
        @customers = Customer.all
        @customer_users = CustomerUser.all
        render :new
      end
    end

    def update
      if @support_ticket.update(support_ticket_params)
        redirect_to operational_portal_support_ticket_path(@support_ticket),
                    notice: 'Support ticket was successfully updated.'
      else
        @customers = Customer.all
        @customer_users = CustomerUser.all
        render :edit
      end
    end

    def destroy
      @support_ticket.destroy!
      redirect_to operational_portal_support_tickets_path, notice: 'Support ticket was successfully deleted.'
    end

    def add_message
      @new_message = @support_ticket.support_ticket_messages.build(message_params)
      @new_message.user = current_user

      if @new_message.save
        redirect_to operational_portal_support_ticket_path(@support_ticket), notice: 'Message was successfully added.'
      else
        render :show
      end
    end

    def preview_message_file
      @support_ticket_message = @support_ticket.support_ticket_messages.find(params[:message_id])
      @file = @support_ticket_message.files.find(params[:file_id])
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end

    def customer_users
      @customer_users = Customer.find(params[:customer_id]).users
      respond_to do |format|
        format.json { render json: @customer_users }
      end
    end

    private

    def set_ticket
      @support_ticket = SupportTicket.find(params[:id])
    end

    def authorize_access
      return if current_user.role == 'admin' || current_user.role == 'manager'

      redirect_to root_path, alert: 'You do not have permission to view or modify support tickets.'
    end

    def support_ticket_params
      params.require(:support_ticket).permit(:issue_description, :status, :customer_id, :title, :user_id, file: [])
    end

    def message_params
      params.require(:support_ticket_message).permit(:body, files: [])
    end

    def log_layout
      Rails.logger.info "Layout: #{self.class.send(:_layout)}"
    end
  end
end
