# frozen_string_literal: true

module OperationalPortal
  class CustomerImportsController < OperationalPortal::AdminOperationController
    load_and_authorize_resource

    def index
      @pagy, @customer_imports = pagy(CustomerImport.accessible_by(current_ability))
    end

    def show; end

    def create
      @customer_import = CustomerImport.new(customer_import_params.merge!(created_by: current_user))

      respond_to do |format|
        if @customer_import.save
          CustomerImportJob.perform_async(@customer_import.id)

          format.turbo_stream { render locals: { ci: @customer_import } }
        else
          format.turbo_stream { render status: :unprocessable_entity }
        end
      end
    end

    private

    def customer_import_params
      params.require(:customer_import).permit(:sheet)
    end
  end
end
