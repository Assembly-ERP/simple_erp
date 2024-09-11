# frozen_string_literal: true

module OperationalPortal
  class ProfilesController < OperationalPortal::NormalOperationController
    authorize_resource class: false

    def show
      @user = current_user
    end

    def edit
      @user = current_user
    end

    def update
      if current_user.update(user_update_params)
        redirect_to operational_portal_profile_path, notice: 'Profile was successfully updated.'
      else
        render :edit
      end
    end

    private

    def user_update_params
      params.require(:user).permit(:email, :name, :phone, :password, :password_confirmation).compact_blank!
    end
  end
end
