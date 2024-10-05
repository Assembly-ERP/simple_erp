# frozen_string_literal: true

module Api
  module V1
    class PartsController < BaseController
      load_and_authorize_resource

      def index
        @parts = Part.accessible_by(current_ability)
        render json: @parts
      end

      def show
        render json: @part
      end

      def create
        @part = Part.new(part_params)
        if @part.save
          render json: @part, status: :created
        else
          render json: @part.errors, status: :unprocessable_entity
        end
      end

      def update
        if @part.update(part_params)
          render json: @part
        else
          render json: @part.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @part.destroy
        render json: { message: 'Part deleted' }, status: :ok
      end

      private

      def part_params
        params.require(:part).permit(:name, :description, :price, :in_stock)
      end
    end
  end
end
