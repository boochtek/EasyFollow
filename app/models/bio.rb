class Bio < ActiveRecord::Base

  attribute :location,    :string, :max_length => 50
  attribute :title,       :string, :max_length => 75
  attribute :industry,    :string, :max_length => 50
  attribute :description, :text,   :max_length => 1000

  belongs_to :user

  # TODO: Replace these with a picture the user has uploaded.
  def picture
    'images/samples/medium_thumb.jpg'
  end
  def thumbnail
    'images/samples/user_thumb.jpg'
  end

end
