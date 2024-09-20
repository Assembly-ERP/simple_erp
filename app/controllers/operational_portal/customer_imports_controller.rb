# frozen_string_literal: true

module OperationalPortal
  class CustomerImportsController < OperationalPortal::AdminOperationController
    load_and_authorize_resource

    def index
      @customer_imports = CustomerImport.accessible_by(current_ability)
    end

    def new; end

    def create
      @customer_import = CustomerImport.new(customer_import_params)

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
