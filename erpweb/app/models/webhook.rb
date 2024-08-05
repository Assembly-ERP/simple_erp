# app/models/webhook.rb
class Webhook < ApplicationRecord
  belongs_to :customer
  belongs_to :user  # Assuming each webhook is linked to a specific user for permission checks

  before_create :generate_secret_token

  private
  def generate_secret_token
    self.secret_token = SecureRandom.hex(20) # Generate a secure random token
  end
end
