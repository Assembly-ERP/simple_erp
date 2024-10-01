# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      authorize_resource class: false, only: :me

      def sign_in; end

      def me; end

      private

      def user_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
