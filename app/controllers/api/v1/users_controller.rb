# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      load_and_authorize_resource

      def index
        @users = User.accessible_by(current_ability)
      end

      def show; end

      def create
        @user = User.new(user_params)

        if @user.save
          @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :role, :phone, :password, :password_confirmation)
      end
    end
  end
end
