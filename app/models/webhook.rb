# frozen_string_literal: true

class Webhook < ApplicationRecord
  # Relationships
  belongs_to :customer
  belongs_to :user

  # Generators
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
