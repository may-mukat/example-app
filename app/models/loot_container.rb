class LootContainer < ApplicationRecord
  has_many :location
  has_one_attached :container_image
  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  # validates_attachment :container_image,
  #   content_type: {
  #     content_type: [
  #       "image_jpg",
  #       "image_jpeg",
  #       "image_png",
  #       "image_gif"
  #     ]
  #   },
  #   size: {
  #     less_than_or_equal_to: 1.megabytes
  #   }
end
