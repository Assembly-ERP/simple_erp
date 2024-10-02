# frozen_string_literal: true

module Api
  module V1
    class AuthController < BaseController
      authorize_resource class: false, only: :me

      def sign_in
        user = User.find_by(email: auth_params[:email])

        if user.present? && user.valid_password?(auth_params[:password])
          render json: auth_tokens(user.id)
        else
          render json: 'Invalid email or password', status: :unprocessable_entity
        end
      end

      def refresh_token
        decoded_token = decoded_token(jwt_key: ENV.fetch('JWT_REFRESH_KEY', nil))

        if decoded_token.present?
          render json: auth_tokens(decoded_token.first['id'])
        else
          render json: 'Invalid refresh token', status: :unauthorized
        end
      end

      def me; end

      private

      def auth_params
        params.require(:user).permit(:email, :password)
      end
    end
  end
end
