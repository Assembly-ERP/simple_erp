# app/controllers/customer_portal/support_tickets_controller.rb
module CustomerPortal
  class SupportTicketsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_ticket, only: [:show, :edit, :update, :destroy, :add_message]
    before_action :authorize_access, only: [:show, :edit, :update, :destroy, :add_message]

    def index
      @support_tickets = if current_user.role == 'customer_user_admin'
        SupportTicket.where(customer_id: current_user.customer_id)
      else
        SupportTicket.where(customer_id: current_user.customer_id, user_id: current_user.id)
      end
    end

    def show
      @support_ticket = SupportTicket.includes(support_ticket_messages: { files_attachments: :blob }).find(params[:id])
      @new_message = SupportTicketMessage.new
    end
    

    def new
      @support_ticket = SupportTicket.new
    end

    def create
      @support_ticket = SupportTicket.new(support_ticket_params)
      @support_ticket.customer = current_user.customer
      @support_ticket.user = current_user 
      if @support_ticket.save
        redirect_to customer_portal_support_ticket_path(@support_ticket), notice: 'Support ticket was successfully created.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @support_ticket.update(support_ticket_params)
        redirect_to customer_portal_support_ticket_path(@support_ticket), notice: 'Support ticket was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @support_ticket.destroy
      redirect_to customer_portal_support_tickets_path, notice: 'Support ticket was successfully deleted.'
    end

    def add_message
      @new_message = @support_ticket.support_ticket_messages.build(message_params)
      @new_message.user = current_user

      if @new_message.save
        redirect_to customer_portal_support_ticket_path(@support_ticket), notice: 'Message was successfully added.'
      else
        render :show
      end
    end

    private

    def set_ticket
      @support_ticket = SupportTicket.find_by(id: params[:id])
      if @support_ticket.nil?
        redirect_to customer_portal_support_tickets_path, alert: "Support ticket not found."
      else
        Rails.logger.debug "Found SupportTicket: #{@support_ticket.inspect}"
      end
    end

    def authorize_access
      if current_user.role == 'customer_user_regular' && @support_ticket.user != current_user
        redirect_to customer_portal_support_tickets_path, alert: "You do not have permission to view or modify this ticket."
      elsif current_user.role == 'customer_user_admin' && @support_ticket.customer != current_user.customer
        redirect_to customer_portal_support_tickets_path, alert: "You do not have permission to view or modify this ticket."
      end
    end

    def support_ticket_params
      params.require(:support_ticket).permit(:issue_description, :status, :customer_id, :title)
    end

    def message_params
      params.require(:support_ticket_message).permit(:body, :files [])
    end
  end
end
