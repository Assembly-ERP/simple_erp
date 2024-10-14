# frozen_string_literal: true

class BaseController < ApplicationController
  def current_ability
    @current_ability ||= Ability.new(nil, 'public')
  end
end
