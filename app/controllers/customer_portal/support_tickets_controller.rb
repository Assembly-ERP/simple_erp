# frozen_string_literal: true

module CustomerPortal
  class SupportTicketsController < CustomerPortal::BaseController
    load_and_authorize_resource

    def index
      @pagy, @support_tickets = pagy(SupportTicket.accessible_by(current_ability))
    end

    def show; end

    def new; end

    def edit; end

    def create
      @support_ticket = current_user.support_tickets.build(support_ticket_params)
      @support_ticket.customer = current_user.customer

      if @support_ticket.save
        redirect_to customer_portal_support_ticket_path(@support_ticket),
                    notice: 'Support ticket was successfully created.'
      else
        render :new
      end
    end

    def update
      if @support_ticket.update(support_ticket_params)
        redirect_to customer_portal_support_ticket_path(@support_ticket),
                    notice: 'Support ticket was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @support_ticket.destroy
      redirect_to customer_portal_support_tickets_path, notice: 'Support ticket was successfully deleted.'
    end

    def messages
      @support_ticket_messages = @support_ticket.support_ticket_messages
    end

    def add_message
      @new_message = @support_ticket.support_ticket_messages.build(message_params)
      @new_message.user = current_user

      respond_to do |format|
        if @new_message.save
          format.turbo_stream
        else
          format.turbo_stream { render status: :unprocessable_entity }
        end
      end
    end

    private

    def support_ticket_params
      params.require(:support_ticket).permit(:issue_description, :title, files: [])
    end

    def message_params
      params.require(:support_ticket_message).permit(:body, files: [])
    end
  end
end
