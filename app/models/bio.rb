class Bio < ActiveRecord::Base

  DEFAULT_PICTURE = '/images/samples/medium_thumb.jpg'
  DEFAULT_THUMBNAIL = '/images/samples/user_thumb.gif'
  ALLOWED_PICTURE_EXTENSIONS = %w{ gif png jpg jpeg } # NOTE: These must be in lower case.

  attribute :location,    :string, :max_length => 50
  attribute :title,       :string, :max_length => 75
  attribute :industry,    :string, :max_length => 50
  attribute :description, :text,   :max_length => 1000

  belongs_to :user

  def picture
    Dir.chdir(Rails.public_path) do
      file = Dir.glob(File.join('images', 'pictures', "#{user.username}.*")).first
      (file and File.exists?(file)) ? File.join('/', file) : DEFAULT_PICTURE
    end
  end

  def thumbnail
    picture # NOTE: For now, we're just having CSS resize the picture as a thumbnail.
  end

  # TODO: Add errors to the object if the picture is invalid.
  def valid?
    super and picture_is_valid?
  end

  # NOTE: The form must have :html => { :multipart => true } set, in order for the uploaded_file to be an UploadedFile instead of a String.
  def picture=(uploaded_file)
    @uploaded_file = uploaded_file
    file_ext = File.extname(uploaded_file.original_filename)
    if picture_is_valid?
      file_to_write = File.join(Rails.public_path, 'images', 'pictures', "#{user.username}#{file_ext}")
      delete_picture_and_thumbnail
      if uploaded_file.instance_of?(Tempfile)
        FileUtils.copy(uploaded_file.local_path, file_to_write)
      else
        File.open(file_to_write, 'wb') { |f| f.write(uploaded_file.read) }
      end
    else
      # TODO: Add errors to the object if the picture is invalid.
    end
  end

  def after_destroy
    delete_picture_and_thumbnail
  end

private

  def delete_picture_and_thumbnail
    Dir.chdir(File.join(Rails.public_path, 'images', 'pictures')) do
      FileUtils.rm(Dir.glob("#{user.username}.*"))
    end
    Dir.chdir(File.join(Rails.public_path, 'images', 'thumbnails')) do
      FileUtils.rm(Dir.glob("#{user.username}.*"))
    end
  end

  def picture_is_valid?
    return true if (@uploaded_file.nil? or @uploaded_file.original_filename.empty?)
    file_ext = File.extname(@uploaded_file.original_filename)
    return ALLOWED_PICTURE_EXTENSIONS.include?(file_ext.downcase)
    # TODO: Should also validate that the file is the type they say it is, and does not contain malware.
  end
end
