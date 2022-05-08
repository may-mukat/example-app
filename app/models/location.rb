class Location < ApplicationRecord
  validates :x_coordinate, :y_coordinate, presence: true
  belongs_to :map
  belongs_to :loot_container
  belongs_to :user
  has_one_attached :near_view
  has_one_attached :distant_view
  has_one_attached :animation_gif
  # validates_attachment :near_view, :distant_view, :animation_gif,
  # content_type: {
  #   content_type: [
  #     "image_jpg",
  #     "image_jpeg",
  #     "image_png",
  #     "image_gif"
  #   ]
  # },
  # size: {
  #   less_than_or_equal_to: 1.megabytes
  # }

end
