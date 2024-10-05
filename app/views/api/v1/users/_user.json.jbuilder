# frozen_string_literal: true

json.extract! user, :id, :name, :email, :role, :advance, :created_at, :updated_at
json.customer user.customer if user.customer_user?
