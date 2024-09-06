# frozen_string_literal: true

module OperationalPortal
  class PartsController < OperationalPortal::NormalOperationController
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
      respond_to do |format|
        if @part.update(voided_at: Time.zone.now)
          format.html { redirect_to operational_portal_catalog_index_path, notice: 'Part was successfully voied.' }
        end
        format.turbo_stream
      end
    end

    private

    def part_params
      params.require(:part).permit(
        :name, :description, :price, :in_stock, :weight, :sku, :length, :width,
        :manual_price, :inventory, images: []
      )
    end
  end
end
