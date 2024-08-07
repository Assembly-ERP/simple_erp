# frozen_string_literal: true

# app/models/user.rb
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable

  belongs_to :customer, optional: true

  # Associations for customer-related data
  has_many :orders, foreign_key: 'customer_id', primary_key: 'customer_id', inverse_of: :customer, dependent: :destroy
  has_many :support_tickets, foreign_key: 'customer_id', primary_key: 'customer_id', inverse_of: :customer,
                             dependent: :destroy

  # Define roles as constants or methods
  ROLES = %w[regular manager admin customer_user_admin customer_user_regular].freeze

  def operational_user?
    role == 'admin' || role == 'manager' || role == 'regular'
  end

  def customer_user?
    role == 'customer_user_admin' || role == 'customer_user_regular'
  end

  # Validate presence of additional attributes
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { message: 'This email is already taken' }

  # Conditional validation for passwords
  validates :password, presence: true, length: { minimum: 8, message: 'at least 8 characters' },
                       if: -> { new_record? || !password.nil? }
  validates :password_confirmation, presence: true, if: -> { password.present? }
  validates :role, inclusion: { in: ROLES }

  # These attributes are only relevant for customer user admins
  with_options if: -> { role == 'customer_user_admin' } do
    validates :customer_name, presence: true
    validates :customer_phone, presence: true
  end

  def as_json(_options = {})
    super(only: %i[id name])
  end

  def remember_me
    super.nil? ? true : super
  end

  attr_accessor :customer_name, :customer_phone, :street, :city, :state, :postal_code, :discount

  private

  def password_required?
    new_record? || password.present?
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  firstName              :string
#  lastName               :string
#  name                   :string
#  phone                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string
#  type                   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  customer_id            :bigint
#
# Indexes
#
#  index_users_on_customer_id           (customer_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
