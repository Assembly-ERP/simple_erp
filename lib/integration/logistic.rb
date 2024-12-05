# frozen_string_literal: true

module Integration
  class Logistic
    def initialize
      @conn = Faraday.new(
        url: 'https://example.com',
        headers: { 'Content-Type' => 'application/json' }
      )
    end

    def ship_order
      response = @conn.post('/ship') do |req|
        req.params['order_details'] = 'some info here'
        # extend params if needed
        # req.body = { query: 'product 1' }.to_json
      end

      logger.debug "ship_order response status: #{response.status}"

      response.status
    end
  end
end
