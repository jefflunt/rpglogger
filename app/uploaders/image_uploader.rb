# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  # I will use file storage with S3FS on the backend to transparently
  # store files on S3
  storage :file

  # The folder where uploads will be stored
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # For display in the section table
  version :thumb do
    process :resize_to_fill => [50, 50]
  end
  
  # Limit upload types to images only
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
