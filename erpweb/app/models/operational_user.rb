# frozen_string_literal: true

# app/models/operational_user.rb
class OperationalUser < User
  # belongs_to :customer
  has_many :support_tickets, dependent: :destroy

  def admin?
    role == 'admin'
  end

  def manager?
    role == 'manager'
  end

  def regular?
    role == 'regular'
  end
end

# validates :email, presence: true, uniqueness: true
# Assumes you are using has_secure_password for password handling
# has_secure_password

# enum role: [:admin, :manager, :employee]  # Define roles as needed
# end
