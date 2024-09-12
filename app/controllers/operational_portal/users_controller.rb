# frozen_string_literal: true

module OperationalPortal
  class UsersController < OperationalPortal::AdminOperationController
    load_and_authorize_resource

    def index
      @users = User.with_customer.accessible_by(current_ability)
    end

    def show; end

    def new; end

    def edit; end

    def create
      @user = User.new(user_params)

      if @user.save
        redirect_to operational_portal_users_path, notice: 'User was successfully created.'
      else
        render :new
      end
    end

    def update
      if @user.update(user_params)
        redirect_to operational_portal_users_path, notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @user.destroy!
      redirect_to operational_portal_users_path, notice: 'User was successfully deleted.'
    end

    private

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :phone, :role, :password, :password_confirmation,
                                   :customer_id)
    end
  end
end
