# frozen_string_literal: true

module Integration
  class Logistic
    def initialize
      @conn = Faraday.new(
        url: 'https://example.com',
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def ship_order; end
  end
end
