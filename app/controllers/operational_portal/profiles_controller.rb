# frozen_string_literal: true

module OperationalPortal
  class ProfilesController < OperationalPortal::BaseController
    authorize_resource class: false

    before_action :set_user

    def show; end

    def edit; end

    def update
      if @user.update(user_params)
        redirect_to operational_portal_profile_path, notice: 'Profile was successfully updated.'
      else
        render :edit
      end
    end

    private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user)
            .permit(:email, :first_name, :last_name, :phone, :password, :password_confirmation)
    end
  end
end
