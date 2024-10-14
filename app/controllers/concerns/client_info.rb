# frozen_string_literal: true

module ClientInfo
  extend ActiveSupport::Concern

  included do
    before_action :current_client

    private

    def current_client
      @client = Branding.client
    end
  end
end
