# frozen_string_literal: true

module OperationalPortal
  class PartsController < OperationalPortal::BaseController
    load_and_authorize_resource

    def index
      @parts = Part.accessible_by(current_ability)
    end

    def show; end

    def new; end

    def edit; end

    def create
      @part = Part.new(part_params)

      respond_to do |format|
        if @part.save
          format.html { redirect_to operational_portal_part_path(@part), notice: 'Part was successfully created.' }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @part.update(part_params)
          format.html { redirect_to operational_portal_part_path(@part), notice: 'Part was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    end

    def destroy
      @part.destroy!
    end

    def search_part_results
      @parts = Part.all
      @parts = @parts.order(id: params[:sort]) if params[:sort].present?
      @parts = @parts.with_product(params[:product_id]) if params[:product_id].present?

      if params[:search].present?
        case params[:filter_by]
        when 'name'
          @parts = @parts.where('name ILIKE ?', "%#{params[:search]}%")
        end
      end

      @parts = @parts.accessible_by(current_ability)

      respond_to do |format|
        format.turbo_stream { render 'operational_portal/products/search_part_results' }
      end
    end

    private

    def part_params
      params.require(:part).permit(:name, :description, :price, :in_stock, :weight, :manual_price, :inventory,
                                   files: [])
    end
  end
end
