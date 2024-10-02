# frozen_string_literal: true

module CustomerPortal
  class SupportTicketsController < BaseController
    load_and_authorize_resource

    def index
      @pagy, @support_tickets = pagy(SupportTicket.accessible_by(current_ability))
    end

    def show; end

    def new; end

    def edit; end

    def create
      @support_ticket = current_user.support_tickets.new(support_ticket_params.merge!(customer: current_user.customer))

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

    private

    def support_ticket_params
      params.require(:support_ticket).permit(:issue_description, :title, files: [])
    end
  end
end
