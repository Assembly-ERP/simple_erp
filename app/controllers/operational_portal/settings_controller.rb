# frozen_string_literal: true

module OperationalPortal
  class SettingsController < OperationalPortal::ManageBaseController
    load_and_authorize_resource

    def index
      @settings = Setting.accessible_by(current_ability)
    end

    def edit; end

    def update
      respond_to do |format|
        if @setting.update(setting_params)
          format.html { redirect_to operational_portal_settings_path, notice: "#{@setting.key} updated successfully." }
          format.turbo_stream
        else
          format.html { render :edit }
          format.turbo_stream { render status: :unprocessable_entity }
        end
      end
    end

    private

    def setting_params
      params.require(:setting).permit(:value)
    end
  end
end
