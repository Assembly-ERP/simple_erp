# app/services/image_resizer.rb
class ImageResizer
  def self.resize(image_path)
    output = Tempfile.new(['resized', '.jpg'])
    ImageProcessing::Vips
    .source(image_path)
    .resize_to_limit(800, 800)
    .convert('jpg')
    .call(destination: output.path)
    output
  end
end