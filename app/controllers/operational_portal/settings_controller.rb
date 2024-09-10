# frozen_string_literal: true

module OperationalPortal
  class SettingsController < OperationalPortal::AdminOperationController
    load_and_authorize_resource

    def index
      @settings = Setting.accessible_by(current_ability)
    end

    def edit; end

    def update
      if @setting.update(setting_params)
        redirect_to operational_portal_settings_path, notice: "#{@setting.key} updated successfully."
      else
        render :edit
      end
    end

    private

    def setting_params
      params.require(:setting).permit(:value)
    end
  end
end
