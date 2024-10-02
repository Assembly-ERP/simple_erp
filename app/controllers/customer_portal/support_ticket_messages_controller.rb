# frozen_string_literal: true

module CustomerPortal
  class SupportTicketMessagesController < BaseController
    load_and_authorize_resource

    def index
      @pagy, @support_ticket_message = pagy(SupportTicketMessage.accessible_by(current_ability))
    end

    def create
      @support_ticket_message =
        current_user.support_ticket_messages.new(support_ticket_params)

      if @support_ticket_message.save
        redirect_to customer_portal_support_ticket_path(support_ticket.support_ticket_message),
                    notice: 'Support ticket was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @support_ticket_message.update(support_ticket_params)
        redirect_to customer_portal_support_ticket_path(support_ticket_message.support_ticket),
                    notice: 'Support ticket message was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @support_ticket.destroy
    end

    private

    def support_ticket_params
      params.require(:support_ticket_message).permit(:body, :support_ticket_id, files: [])
    end
  end
end
