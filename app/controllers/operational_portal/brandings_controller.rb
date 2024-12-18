# frozen_string_literal: true

module OperationalPortal
  class BrandingsController < OperationalPortal::ManageBaseController
    load_and_authorize_resource

    before_action :set_branding

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

    def set_branding
      @branding = Branding.client
    end

    def branding_params
      params.require(:branding).permit(
        :name, :ein, :phone, :street, :city, :state, :postal_code, :about_us,
        :primary_color, :primary_text_color, :secondary_color, :secondary_text_color,
        :logo
      )
    end
  end
end
