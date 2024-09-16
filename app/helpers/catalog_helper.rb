# frozen_string_literal: true

module CatalogHelper
  def catalog_path
    path = ''
    path += "#{request.fullpath}.turbo_stream" unless request.fullpath.include?('.turbo_stream')

    path += if request.fullpath.include?('?')
              "#{request.fullpath}&more=true"
            else
              "#{request.fullpath}?modal=true"
            end

    path
  end
end
