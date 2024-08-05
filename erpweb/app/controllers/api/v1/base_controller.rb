# app/controllers/api/v1/base_controller.rb
module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :authenticate_request

      private

      def authenticate_api_user!
        token = request.headers['Authorization']&.split(' ')&.last
        if token
          begin
            decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')
            @current_user = User.find(decoded_token[0]['user_id'])
          rescue JWT::DecodeError, ActiveRecord::RecordNotFound
            render json: { error: 'Unauthorized access' }, status: :unauthorized
          end
        else
          render json: { error: 'Token not provided' }, status: :unauthorized
        end
      end
     
     def current_user
     @current_user
     end

     def authenticate_token(token)
      begin
        decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' })
        User.find(decoded_token[0]['user_id'])
      rescue JWT::DecodeError
        nil
        end
      end
    end
  end
end
