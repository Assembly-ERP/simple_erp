# frozen_string_literal: true

class OrderAssignee < ApplicationRecord
  belongs_to :order
  belongs_to :user
end
