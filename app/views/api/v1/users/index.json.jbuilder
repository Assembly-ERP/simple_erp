# frozen_string_literal: true

json.array! @users do |user|
  json.partial! user, as: :user
end
