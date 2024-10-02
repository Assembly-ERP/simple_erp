# frozen_string_literal: true

class Api::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session

  private

  def encode_token(payload, jwt_key:, exp: 30.minutes.from_now)
    return nil if payload.blank? || jwt_key.blank?

    payload[:exp] = exp.to_i
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

  def auth_tokens(id)
    jwt_access_key = ENV.fetch('JWT_ACCESS_KEY', nil)
    jwt_refresh_key = ENV.fetch('JWT_REFRESH_KEY', nil)

    {
      access_token: encode_token({ id: }, jwt_key: jwt_access_key),
      refresh_token: encode_token({ id: }, jwt_key: jwt_refresh_key, exp: 3.hours.from_now)
    }
  end
end
