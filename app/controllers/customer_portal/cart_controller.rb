# frozen_string_literal: true

module CustomerPortal
  class CartController < BaseController
    authorize_resource class: false

    def index
      @carts = []

      signed_carts.each do |key, hash|
        id = key.split(':').first
        item = cart_item(id, hash['type'])

        next if item.blank?

        @carts << {
          id:,
          name: item.name,
          desription: item.description,
          type: hash['type'],
          quantity: hash['quantity']
        }
      end
    end

    def create
      respond_to do |format|
        if carts_params[:id].present? || carts_params[:quantity].to_i.positive?
          carts = signed_carts
          item = "#{carts_params[:id]}:#{carts_params[:type]}"

          carts[item] = { type: carts_params[:type], quantity: carts_params[:quantity].to_i }
          cookies.signed.permanent[:carts] = JSON.generate(carts)

          format.turbo_stream { render locals: { error: false } }
        else
          format.turbo_stream { render locals: { error: true }, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      carts = signed_carts

      respond_to do |format|
        if params[:id].blank? || params[:type].blank?

          item = "#{params[:id]}:#{params[:type]}"
          carts.delete(item)

          cookies.signed.permanent[:carts] = JSON.generate(carts)

          format.turbo_stream { render locals: { error: false } }
        else
          format.turbo_stream { render locals: { error: true }, status: :unprocessable_entity }
        end
      end
    end

    private

    def signed_carts
      JSON.parse(cookies.signed[:carts] || '{}')
    end

    def cart_item(id, type)
      case type
      when 'product'
        Product.find_by(id:)
      else
        Part.find_by(id:)
      end
    end

    def carts_params
      params.require(:cart).permit(:id, :type, :quantity)
    end
  end
end
