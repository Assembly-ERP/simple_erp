# frozen_string_literal: true

# app/models/customer_user.rb
class CustomerUser < User
  belongs_to :customer
  has_many :support_tickets, dependent: :destroy
  has_one :cart, dependent: :destroy

  def customer_user_admin?
    role == 'customer_user_admin'
  end

  def customer_user_regular?
    role == 'customer_user_regular'
  end
end
