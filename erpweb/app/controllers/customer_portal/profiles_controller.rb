module CustomerPortal
  class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_customer_user

    def show
      @user = current_user
    end

    def edit
      @user = current_user
    end

    def update
      @user = current_user
      if @user.update(user_update_params)
        redirect_to customer_portal_profile_path, notice: 'Profile was successfully updated.'
      else
        render :edit
      end
    end

    private

    def ensure_customer_user
      redirect_to root_path, alert: 'Access denied!' unless current_user.customer_user?
    end

   def user_update_params
      params.require(:user).permit(:email, :name, :phone, :password, :password_confirmation).delete_if { |key, value| value.blank? }
    end
  end
end
