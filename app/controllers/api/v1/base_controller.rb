# frozen_string_literal: true

module Api
  module V1
    class BaseController < Api::BaseController
      rescue_from CanCan::AccessDenied do |_exception|
        if current_user.present?
          render json: 'forbidden', status: :forbidden
        else
          render json: 'unauthorized', status: :unauthorized
        end
      end

      def current_ability
        @current_ability ||= Ability.new(current_user, Portal::API_V1)
      end

      def current_user
        @current_user ||= api_user
      end

      private

      def api_user
        decoded_token = decoded_token(jwt_key: ENV.fetch('JWT_ACCESS_KEY', nil))
        return nil if decoded_token.blank?

        User.find_by(id: decoded_token.first['id'])
      end
    end
  end
end
