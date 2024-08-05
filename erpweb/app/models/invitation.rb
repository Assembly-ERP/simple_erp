class Invitation < ApplicationRecord
  belongs_to :customer
  before_create :generate_token

  private

  def generate_token
    self.token = SecureRandom.hex(10)
  end
end
