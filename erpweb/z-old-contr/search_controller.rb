# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    @query = params[:query]
    @products = Product.where('name ILIKE ?', "%#{params[:query]}%")
    @parts = Part.where('name ILIKE ?', "%#{params[:query]}%")
  end
end
