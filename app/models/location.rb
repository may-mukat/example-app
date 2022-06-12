class Location < ApplicationRecord
  belongs_to :map
  belongs_to :loot_container
  belongs_to :user
  has_one_attached :near_view
  has_one_attached :distant_view
  has_one_attached :animation_gif

  validates :x_coordinate, :y_coordinate, presence: true
  validate :correct_image
  validate :correct_gif

  private
    def correct_image
      images = [near_view, distant_view]
      images.each do |image|
        if image.attached? && !image.content_type.in?(%w(image/jpg image/jpeg image/png image/gif image/webp))
          errors.add(image.name.to_sym, "で選択されているファイルは不正です。")
        end
      end
    end

    def correct_gif
      if animation_gif.attached? && !animation_gif.content_type.in?(%w(image/gif))
        errors.add(:animation_gif, "で選択されているファイルは不正です。")
      end
    end
end
