# app/controllers/api/v1/support_tickets_controller.rb
module Api
  module V1
    class SupportTicketsController < BaseController
      before_action :set_support_ticket, only: [:show, :update, :destroy]

      def index
        @support_tickets = SupportTicket.all
        render json: @support_tickets
      end

      def show
        render json: @support_ticket
      end

      def create
        @support_ticket = SupportTicket.new(support_ticket_params)
        if @support_ticket.save
          render json: @support_ticket, status: :created
        else
          render json: @support_ticket.errors, status: :unprocessable_entity
        end
      end

      def update
        if @support_ticket.update(support_ticket_params)
          render json: @support_ticket
        else
          render json: @support_ticket.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @support_ticket.destroy
        render json: { message: 'Support ticket deleted' }, status: :ok
      end

      private

      def set_support_ticket
        @support_ticket = SupportTicket.find(params[:id])
      end

      def support_ticket_params
        params.require(:support_ticket).permit(:title, :description, :status, :customer_id)
      end
    end
  end
end
