# frozen_string_literal: true

module OperationalPortal
  class SupportTicketsController < OperationalPortal::NormalOperationController
    load_and_authorize_resource

    def index
      @support_tickets = SupportTicket.with_customer.accessible_by(current_ability)
    end

    def show; end

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

    def messages
      @support_ticket_messages = @support_ticket.support_ticket_messages
    end

    def add_message
      @new_message = @support_ticket.support_ticket_messages.build(message_params)
      @new_message.user = current_user

      respond_to do |format|
        if @new_message.save
          format.turbo_stream { render locals: { errors: nil } }
        else
          format.turbo_stream { render status: :unprocessable_entity, locals: { errors: @new_message.errors.full_messages } }
        end
      end
    end

    private

    def support_ticket_params
      params.require(:support_ticket).permit(:issue_description, :status, :customer_id, :title, :user_id, files: [])
    end

    def message_params
      params.require(:support_ticket_message).permit(:body, files: [])
    end
  end
end
