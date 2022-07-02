class LootContainer < ApplicationRecord
  has_many :location
  has_one_attached :container_image

  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  validate :correct_image_type
  validate :correct_image_size

  private
    @@image_types = %w(image/jpg image/jpeg image/gif)
    @@image_limit_size = 10

    def correct_image_type
      if container_image.attached? && !container_image.content_type.in?(@@image_types)
        errors.add(:container_image, :file_format_different)
      end
    end

    def correct_image_size
      if container_image.attached? && container_image.byte_size > @@image_limit_size.kilobytes
        errors.add(:container_image, :file_size_large, limit: "#{@@image_limit_size}KB")
      end
    end
end
