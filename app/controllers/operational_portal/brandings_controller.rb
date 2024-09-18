# frozen_string_literal: true

module OperationalPortal
  class BrandingsController < OperationalPortal::AdminOperationController
    load_and_authorize_resource

    def index
      @branding = Branding.client
    end

    def update
      respond_to do |format|
        if @branding.update(branding_params)
          format.html do
            redirect_to operational_portal_settings_path(accordion: ['branding']),
                        notice: 'Branding updated successfully.'
          end
          format.turbo_stream
        else
          format.html { render :index, status: :unprocessable_entity }
          format.turbo_stream { render status: :unprocessable_entity }
        end
      end
    end

    private

    def branding_params
      params.require(:branding).permit(
        :name, :ein, :phone,
        # Address
        :street, :city, :state, :postal_code,
        # Theme
        :primary_color, :primary_text_color,
        :secondary_color, :secondary_text_color
      )
    end
  end
end
