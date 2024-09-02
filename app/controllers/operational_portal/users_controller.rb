# frozen_string_literal: true

module OperationalPortal
  class UsersController < OperationalPortal::AdminOperationController
    load_and_authorize_resource

    def index
      @users = User.all
    end

    def show; end

    def new
      @user = User.new
      @customers = Customer.all
    end

    def edit
      @customers = Customer.all
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to operational_portal_users_path, notice: 'User was successfully created.'
      else
        @customers = Customer.all
        render :new
      end
    end

    def update
      key = if params[:user]
              :user
            else
              (params[:customer_user] ? :customer_user : nil)
            end
      if key.nil?
        redirect_to edit_operational_portal_user_path(@user), alert: 'Invalid parameters.'
        return
      end

      if params[key][:password].blank? && params[key][:password_confirmation].blank?
        if @user.update(params.require(key).permit(:email, :name, :phone, :role, :customer_id))
          redirect_to operational_portal_user_path(@user), notice: 'User was successfully updated.'
        else
          @customers = Customer.all
          render :edit
        end
      elsif @user.update(params.require(key).permit(:email, :name, :phone, :role, :password, :password_confirmation,
                                                    :customer_id))
        redirect_to operational_portal_user_path(@user), notice: 'User was successfully updated.'
      else
        @customers = Customer.all
        render :edit
      end
    end

    def destroy
      @user.destroy!
      redirect_to operational_portal_users_path, notice: 'User was successfully deleted.'
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def ensure_operational_user
      redirect_to root_path unless current_user.operational_user?
    end

    def user_params
      params.require(:user).permit(:email, :name, :phone, :role, :password, :password_confirmation, :customer_id)
    end

    def user_update_params
      key = params[:user] ? :user : :customer_user
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params.require(key).permit(:email, :name, :phone, :role, :customer_id)
      else
        params.require(key).permit(:email, :name, :phone, :role, :password, :password_confirmation, :customer_id)
      end
    end
  end
end
