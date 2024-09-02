# frozen_string_literal: true

module OperationalPortal
  class SupportTicketsController < OperationalPortal::NormalOperationController
    load_and_authorize_resource

    def index
      @support_tickets = SupportTicket.with_customer.accessible_by(current_ability)
    end

    def show
      @support_ticket_messages = @support_ticket.support_ticket_messages.with_user
    end

    def new; end

    def edit; end

    def create
      @support_ticket = SupportTicket.new(support_ticket_params)
      if @support_ticket.save
        redirect_to operational_portal_support_ticket_path(@support_ticket),
                    notice: 'Support ticket was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @support_ticket.update(support_ticket_params)
        redirect_to operational_portal_support_ticket_path(@support_ticket),
                    notice: 'Support ticket was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @support_ticket.destroy!
      redirect_to operational_portal_support_tickets_path, notice: 'Support ticket was successfully deleted.'
    end

    def form_user_selection
      @users =
        (if params[:customer_id].present?
           User.where(customer_id: params[:customer_id])
         else
           User.all
         end)

      respond_to do |format|
        format.turbo_stream
      end
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
      params.require(:support_ticket).permit(:issue_description, :status, :customer_id, :title, :user_id, files: [])
    end

    def message_params
      params.require(:support_ticket_message).permit(:body, files: [])
    end

    def log_layout
      Rails.logger.info "Layout: #{self.class.send(:_layout)}"
    end
  end
end
