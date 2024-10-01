# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      protect_from_forgery with: :null_session

      rescue_from CanCan::AccessDenied do |_exception|
        if current_user.present?
          render json: 'forbidden', status: :forbidden
        else
          render json: 'unauthorized', status: :unauthorized
        end
      end

      def current_ability
        @current_ability ||= Ability.new(current_user, 'api')
      end

      def current_user
        @current_user ||= api_user
      end

      private

      def encode_token(payload:, jwt_key:)
        JWT.encode(payload, jwt_key, 'HS256')
      end

      def decoded_token(jwt_key: nil)
        return nil if jwt_key.blank?

        header = request.headers['Authorization']
        return nil unless header.present? && header.split.first == 'Bearer'
        return nil if (token = header.split&.last).blank?

        begin
          JWT.decode(token, jwt_key, true, algorithm: 'HS256')
        rescue JWT::DecodeError
          nil
        end
      end

      def api_user
        decoded_token = decoded_token(jwt_key: ENV.fetch('JWT_SECRET', nil))
        return nil if decoded_token.blank?

        @current_api_user = User.find_by(id: decoded_token[0]['user_id'], advance: true)
      end
    end
  end
end
