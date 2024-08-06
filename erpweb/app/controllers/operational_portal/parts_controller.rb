# app/controllers/operational_portal/parts_controller.rb
module OperationalPortal
  class PartsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_operational_user
    before_action :set_part, only: %i[show edit update destroy delete_file]

    def index
      @parts = Part.all
    end

    def show; end

    def new
      @part = Part.new
    end

    def create
      @part = Part.new(part_params.except(:files))
      Rails.logger.info "Part Params: #{part_params.inspect}"
      @part.price = calculate_price(@part) unless @part.manual_price?

      if @part.save
        attach_files(@part, part_params[:files]) if part_params[:files].present?
        redirect_to operational_portal_part_path(@part), notice: 'Part was successfully created.'
      else
        render :new
      end
    end

    def edit; end

    def update
      respond_to do |format|
        if @part.update(part_params)
          attach_files(@part, part_params[:files])
          format.html { redirect_to operational_portal_part_path(@part), notice: 'Part was successfully updated.' }
          format.json { render :show, status: :ok, location: @part }
        else
          format.html { render :edit }
          format.json { render json: @part.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @part = Part.find(params[:id])
      @part.destroy
      redirect_to operational_portal_catalog_path, notice: 'Part was successfully deleted.'
    end

    def delete_file
      file = @part.files.find(params[:file_id])
      file.purge_later
      redirect_to edit_operational_portal_part_path(@part), notice: 'File was successfully deleted.'
    rescue ActiveRecord::RecordNotFound
      redirect_to edit_operational_portal_part_path(@part), alert: 'File not found.'
    end

    def upload_file
      @part = Part.find(params[:id])
      if @part
        Rails.logger.info "Uploading files for part: #{@part.inspect}"
        attach_files(@part, params[:files])
        redirect_to edit_operational_portal_part_path(@part), notice: 'Files were successfully uploaded.'
      else
        Rails.logger.error "Part not found for ID: #{params[:id]}"
        redirect_to edit_operational_portal_part_path(@part), alert: 'Part not found.'
      end
    end

    private

    def attach_files(part, files)
      return unless files

      files.reject(&:blank?).each do |file|
        next unless file.is_a?(ActionDispatch::Http::UploadedFile)

        Rails.logger.info "Processing file: #{file.original_filename} for part: #{part.name}"

        if file.content_type.start_with?('image')
          processed_image = ImageResizer.resize(file.tempfile.path)
          new_filename = generate_filename(part, file)
          part.files.attach(io: File.open(processed_image.path), filename: new_filename, content_type: 'image/jpeg')
        else
          new_filename = generate_filename(part, file)
          part.files.attach(io: file, filename: new_filename, content_type: file.content_type)
        end
      end
    end

    def generate_filename(part, file)
      extension = File.extname(file.original_filename)
      part_name = part.name.parameterize
      count = part.files.count + 1
      file_type_prefix = case file.content_type
                         when 'image/jpeg', 'image/png', 'image/gif'
                           'image'
                         when 'application/pdf'
                           'pdf'
                         else
                           'file'
                         end
      "#{part_name}_#{file_type_prefix}_#{count}#{extension}"
    end

    def file_type(content_type)
      case content_type
      when 'image/jpeg', 'image/png', 'image/gif'
        'image'
      when 'application/pdf'
        'pdf'
      else
        'file'
      end
    end

    def set_part
      @part = Part.find(params[:id])
    end

    def part_params
      params.require(:part).permit(:name, :description, :price, :in_stock, :weight, :manual_price, :inventory,
                                   files: [])
    end

    def calculate_price(part)
      price_per_pound = Setting.find_by(key: 'Price Per Pound')&.value.to_f
      part.weight.to_f * price_per_pound
    end
  end
end
