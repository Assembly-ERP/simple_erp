# frozen_string_literal: true

module CustomerPortal
  class ProfilesController < CustomerPortal::BaseController
    authorize_resource class: false

    before_action :set_user

    def show; end

    def edit; end

    def update
      if @user.update(user_params)
        redirect_to customer_portal_profile_path, notice: 'Profile was successfully updated.'
      else
        render :edit
      end
    end

    private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :phone, :password, :password_confirmation)
    end
  end
end
