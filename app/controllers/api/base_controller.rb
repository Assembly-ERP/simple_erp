# frozen_string_literal: true

class Api::BaseController < ApplicationController
  protect_from_forgery with: :null_session

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
end
