class Transporter < ApplicationRecord
  validates :name, presence: true
  validates :contact_info, presence: true
end
