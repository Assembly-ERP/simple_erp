# frozen_string_literal: true

class User < ApplicationRecord
  # Constants
  OPERATION_ROLES = %w[regular manager admin].freeze
  CUSTOMER_ROLES = %w[customer_user_admin customer_user_regular].freeze
  ROLES = OPERATION_ROLES + CUSTOMER_ROLES

  # Devise: Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable, :invitable

  # Relationship
  belongs_to :customer, optional: true

  has_many :poly_attributes, as: :attributable, dependent: :destroy
  has_many :support_tickets, dependent: :destroy
  has_many :support_ticket_messages, dependent: :destroy

  accepts_nested_attributes_for :customer

  # Scopes
  scope :with_customer, lambda {
    select('users.*, customers.name AS customer_name')
      .joins('LEFT JOIN customers ON customers.id = users.customer_id')
  }

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :customer, presence: true, if: :customer_user?
  validates :email, presence: true, uniqueness: { message: 'This email is already taken' }
  validates :role, inclusion: { in: ROLES, message: 'Invalid role' }

  # Generators
  before_validation :fill_or_default_role
  before_validation :role_customer_sanitizer
  before_validation :temporary_password, if: :new_record?

  def remember_me
    super.nil? ? true : super
  end

  def name
    "#{first_name} #{last_name}"
  end

  def operational_user?
    OPERATION_ROLES.include?(role)
  end

  def advance_admin_user?
    role == 'admin' && advance
  end

  def customer_user?
    CUSTOMER_ROLES.include?(role)
  end

  private

  def fill_or_default_role
    self.role ||= 'regular'
  end

  def role_customer_sanitizer
    return unless operational_user?

    self.customer_id = nil
  end

  def temporary_password
    return if password.present?

    self.password = Devise.friendly_token[0, 20]
    self.password_confirmation = password
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  advance                :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  last_name              :string           not null
#  phone                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string           not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  customer_id            :bigint
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_customer_id           (customer_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by            (invited_by_type,invited_by_id)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#
