# frozen_string_literal: true

module OperationalPortal
  class CustomerImportsController < OperationalPortal::AdminOperationController
    load_and_authorize_resource

    def index
      query_instance = CustomerImport.accessible_by(current_ability)

      @pagy, @customer_imports = pagy(query_instance)
    end

    def create
      @customer_import = current_user.customer_imports.new(customer_import_params)

      respond_to do |format|
        if @customer_import.save
          format.turbo_stream
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
