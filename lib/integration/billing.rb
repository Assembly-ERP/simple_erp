# frozen_string_literal: true

module Integration
  class Billing
    def initialize
      @conn = Faraday.new(
        url: 'https://example.com',
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def pay_order; end
  end
end
