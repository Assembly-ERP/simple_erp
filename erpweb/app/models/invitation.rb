# frozen_string_literal: true

class Invitation < ApplicationRecord
  belongs_to :customer
  before_create :generate_token

  private

  def generate_token
    self.token = SecureRandom.hex(10)
  end
end

# == Schema Information
#
# Table name: invitations
#
#  id          :bigint           not null, primary key
#  email       :string
#  token       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :bigint           not null
#
# Indexes
#
#  index_invitations_on_customer_id  (customer_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
