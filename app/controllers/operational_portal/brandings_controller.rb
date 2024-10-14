# frozen_string_literal: true

module OperationalPortal
  class BrandingsController < OperationalPortal::AdminOperationController
    load_and_authorize_resource

    def edit; end

    def update
      respond_to do |format|
        if @branding.update(branding_params)
          format.html { redirect_to operational_portal_settings_path }
          format.turbo_stream
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream { render status: :unprocessable_entity }
        end
      end
    end

    private

    def branding_params
      params.require(:branding).permit(
        :name, :ein, :phone, :street, :city, :state, :postal_code, :about_us,
        :primary_color, :primary_text_color, :secondary_color, :secondary_text_color,
        :logo
      )
    end
  end
end
