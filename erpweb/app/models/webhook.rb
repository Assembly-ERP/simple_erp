# frozen_string_literal: true

# app/models/webhook.rb
class Webhook < ApplicationRecord
  belongs_to :customer
  belongs_to :user # Assuming each webhook is linked to a specific user for permission checks

  before_create :generate_secret_token

  private

  def generate_secret_token
    self.secret_token = SecureRandom.hex(20) # Generate a secure random token
  end
end

# == Schema Information
#
# Table name: webhooks
#
#  id           :bigint           not null, primary key
#  secret_token :string
#  url          :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  customer_id  :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_webhooks_on_customer_id  (customer_id)
#  index_webhooks_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (user_id => users.id)
#
