# frozen_string_literal: true

# app/controllers/api/v1/parts_controller.rb
module Api
  module V1
    class PartsController < BaseController
      before_action :set_part, only: %i[show update destroy]

      # GET /api/v1/parts
      def index
        @parts = Part.all
        render json: @parts
      end

      # GET /api/v1/parts/:id
      def show
        render json: @part
      end

      # POST /api/v1/parts
      def create
        @part = Part.new(part_params)
        if @part.save
          render json: @part, status: :created
        else
          render json: @part.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/parts/:id
      def update
        if @part.update(part_params)
          render json: @part
        else
          render json: @part.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/parts/:id
      def destroy
        @part.destroy
        render json: { message: 'Part deleted' }, status: :ok
      end

      private

      def set_part
        @part = Part.find(params[:id])
      end

      def part_params
        params.require(:part).permit(:name, :description, :price, :in_stock)
      end
    end
  end
end
