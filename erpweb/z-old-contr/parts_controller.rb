# frozen_string_literal: true

class PartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @parts = if params[:query].present?
               Parts.where('name ILIKE ?', "%#{params[:query]}%")
             else
               Parts.all
             end
  end

  def show
    @parts = Parts.find(params[:id])
  end
end
