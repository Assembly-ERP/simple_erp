# frozen_string_literal: true

module OperationalPortal
  class BillingsController < OperationalPortal::ManageBaseController
    load_and_authorize_resource

    before_action :set_billing

    def edit; end

    def update
      respond_to do |format|
        if @billing.update(billing_params)
          format.turbo_stream
        else
          format.turbo_stream { render status: :unprocessable_entity }
        end
      end
    end

    private

    def set_billing
      @billing = Billing.client
    end

    def billing_params
      params.require(:billing).permit(:manual_payment, :enable_integration, :pay_later)
    end
  end
end
