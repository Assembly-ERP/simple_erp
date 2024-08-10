# frozen_string_literal: true

module OperationalPortal
  class ProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_operational_user

    def show
      @user = current_user
    end

    def edit
      @user = current_user
    end

    def update
      @user = current_user
      if @user.update(user_update_params)
        redirect_to operational_portal_profile_path, notice: 'Profile was successfully updated.'
      else
        render :edit
      end
    end

    private

    def ensure_operational_user
      redirect_to customer_root_path unless current_user.operational_user?
    end

    def user_update_params
      params.require(:user).permit(:email, :name, :phone, :password, :password_confirmation).compact_blank!
    end
  end
end
